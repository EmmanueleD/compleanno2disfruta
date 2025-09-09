import { createClient } from "@supabase/supabase-js";

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

console.log('Supabase URL:', supabaseUrl);
console.log('Supabase Key exists:', !!supabaseAnonKey);

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('Environment variables:', {
    PUBLIC_SUPABASE_URL: import.meta.env.PUBLIC_SUPABASE_URL,
    PUBLIC_SUPABASE_ANON_KEY: import.meta.env.PUBLIC_SUPABASE_ANON_KEY ? 'exists' : 'missing'
  });
  throw new Error("Missing Supabase environment variables");
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export type Workshop = {
  id: number;
  name: string;
  max_participants?: number;
  created_at: string;
};

export type Session = {
  id: number;
  workshop_id: number;
  session_number: number;
  current_participants: number;
  created_at: string;
};

export type Registration = {
  id: number;
  nome: string;
  cognome: string;
  email: string;
  quilling_session: number;
  ricamo_session: number;
  psicologia_session: number;
  created_at: string;
};
