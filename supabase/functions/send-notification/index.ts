import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { create, getNumericDate } from "https://deno.land/x/djwt@v3.0.2/mod.ts";

interface NotificationPayload {
  topic: string;
  title: string;
  body: string;
  data?: Record<string, string>;
}

interface ServiceAccount {
  project_id: string;
  private_key: string;
  client_email: string;
}

async function getAccessToken(sa: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const jwt = await create(
    { alg: "RS256", typ: "JWT" },
    {
      iss: sa.client_email,
      scope: "https://www.googleapis.com/auth/firebase.messaging",
      aud: "https://oauth2.googleapis.com/token",
      exp: getNumericDate(3600),
      iat: getNumericDate(0),
    },
    await crypto.subtle.importKey(
      "pkcs8",
      pemToArrayBuffer(sa.private_key),
      { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
      false,
      ["sign"],
    ),
  );

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    throw new Error(`Token exchange failed: ${err}`);
  }

  const data = await res.json();
  return data.access_token;
}

function pemToArrayBuffer(pem: string): ArrayBuffer {
  const b64 = pem
    .replace(/-----BEGIN [\w\s]+-----/, "")
    .replace(/-----END [\w\s]+-----/, "")
    .replace(/\s/g, "");
  const bytes = Uint8Array.from(atob(b64), (c) => c.charCodeAt(0));
  return bytes.buffer;
}

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  const serviceAccountJson = Deno.env.get("FCM_SERVICE_ACCOUNT");
  if (!serviceAccountJson) {
    return new Response("FCM_SERVICE_ACCOUNT not configured", { status: 500 });
  }

  let sa: ServiceAccount;
  try {
    sa = JSON.parse(serviceAccountJson);
  } catch {
    return new Response("Invalid FCM_SERVICE_ACCOUNT JSON", { status: 500 });
  }

  let payload: NotificationPayload;
  try {
    payload = await req.json();
  } catch {
    return new Response("Invalid JSON", { status: 400 });
  }

  const { topic, title, body, data } = payload;
  if (!topic || !title || !body) {
    return new Response("Missing required fields: topic, title, body", { status: 400 });
  }

  let accessToken: string;
  try {
    accessToken = await getAccessToken(sa);
  } catch (e) {
    return new Response(`Auth failed: ${e}`, { status: 502 });
  }

  const fcmPayload = {
    message: {
      topic,
      notification: { title, body },
      data: data ?? {},
      android: { priority: "high", notification: { channel_id: "nesta_channel" } },
    },
  };

  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${accessToken}`,
      },
      body: JSON.stringify(fcmPayload),
    },
  );

  if (!res.ok) {
    const err = await res.text();
    return new Response(`FCM error: ${err}`, { status: 502 });
  }

  const result = await res.json();
  return new Response(JSON.stringify(result), {
    headers: { "Content-Type": "application/json" },
  });
});
