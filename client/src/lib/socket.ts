import { io, type Socket } from "socket.io-client";

let socket: Socket | null = null;

const SOCKET_URL =
  (import.meta as any).env?.VITE_SOCKET_URL ||
  (typeof window !== "undefined" ? window.location.origin : undefined);

export function getSocket() {
  return socket;
}

export function connectSocket(accessToken: string) {
  if (socket?.connected) return socket;

  socket = io(SOCKET_URL, {
    path: "/socket.io",
    transports: ["websocket", "polling"],
    auth: {
      accessToken,
    },
  });

  return socket;
}

export function disconnectSocket() {
  socket?.disconnect();
  socket = null;
}
