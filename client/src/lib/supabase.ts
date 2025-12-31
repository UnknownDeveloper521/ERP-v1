import { createClient } from "@supabase/supabase-js";

// ⚠️ IMPORTANT: Replace this key with YOUR CORRECT Supabase anon key
// Get it from: https://app.supabase.co/project/zpecwgqgsjwjrfrfrzzq/settings/api
// Under "anon public" section - copy the FULL key

const SUPABASE_URL = "https://zpecwgqgsjwjrfrfrzzq.supabase.co";
const SUPABASE_ANON_KEY = "YOUR_CORRECT_ANON_KEY_HERE"; // 👈 REPLACE THIS!

if (SUPABASE_ANON_KEY === "YOUR_CORRECT_ANON_KEY_HERE") {
  console.error(
    "❌ CRITICAL: Invalid API Key!\n" +
    "Please copy your CORRECT Supabase anon key from:\n" +
    "https://app.supabase.co/project/zpecwgqgsjwjrfrfrzzq/settings/api\n" +
    "Then replace 'YOUR_CORRECT_ANON_KEY_HERE' in client/src/lib/supabase.ts"
  );
}

console.log("🔗 Supabase URL:", SUPABASE_URL);

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Helper functions
export const signUpWithEmail = async (email: string, password: string) => {
  return supabase.auth.signUp({ email, password });
};

export const signInWithEmail = async (email: string, password: string) => {
  return supabase.auth.signInWithPassword({ email, password });
};

export const signOut = async () => {
  return supabase.auth.signOut();
};

export const getCurrentUser = async () => {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  return user;
};

export const onAuthStateChange = (callback: (user: any) => void) => {
  return supabase.auth.onAuthStateChange((event, session) => {
    callback(session?.user ?? null);
  });
};
