-- Create workshops table
CREATE TABLE workshops (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    max_participants INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create sessions table
CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    workshop_id INTEGER REFERENCES workshops(id),
    session_number INTEGER NOT NULL,
    current_participants INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(workshop_id, session_number)
);

-- Create registrations table
CREATE TABLE registrations (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cognome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    quilling_session INTEGER NOT NULL CHECK (quilling_session IN (1, 2, 3)),
    ricamo_session INTEGER NOT NULL CHECK (ricamo_session IN (1, 2, 3)),
    psicologia_session INTEGER NOT NULL CHECK (psicologia_session IN (1, 2, 3)),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert initial workshop data
INSERT INTO workshops (name, max_participants) VALUES 
    ('Laboratorio di Quilling', NULL),
    ('Laboratorio di Ricamo', NULL),
    ('Laboratorio di Psicologia', 15);

-- Insert sessions for each workshop (3 sessions each)
INSERT INTO sessions (workshop_id, session_number) VALUES 
    (1, 1), (1, 2), (1, 3),  -- Quilling sessions
    (2, 1), (2, 2), (2, 3),  -- Ricamo sessions
    (3, 1), (3, 2), (3, 3);  -- Psicologia sessions

-- Create function to update session participant count
CREATE OR REPLACE FUNCTION update_session_participants()
RETURNS TRIGGER AS $$
BEGIN
    -- Update participant count for psychology sessions
    UPDATE sessions 
    SET current_participants = (
        SELECT COUNT(*) 
        FROM registrations 
        WHERE psicologia_session = sessions.session_number
    )
    WHERE workshop_id = 3;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update participant counts
CREATE TRIGGER update_participants_trigger
    AFTER INSERT OR UPDATE OR DELETE ON registrations
    FOR EACH ROW
    EXECUTE FUNCTION update_session_participants();

-- Create function to check psychology session capacity
CREATE OR REPLACE FUNCTION check_psychology_capacity()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if psychology session is at capacity
    IF (SELECT current_participants FROM sessions 
        WHERE workshop_id = 3 AND session_number = NEW.psicologia_session) >= 15 THEN
        RAISE EXCEPTION 'La sessione % del Laboratorio di Psicologia è al completo (massimo 15 partecipanti)', NEW.psicologia_session;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to check capacity before insertion
CREATE TRIGGER check_capacity_trigger
    BEFORE INSERT OR UPDATE ON registrations
    FOR EACH ROW
    EXECUTE FUNCTION check_psychology_capacity();

-- Enable Row Level Security
ALTER TABLE workshops ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE registrations ENABLE ROW LEVEL SECURITY;

-- Create policies for public access (adjust as needed for production)
CREATE POLICY "Allow public read access on workshops" ON workshops FOR SELECT USING (true);
CREATE POLICY "Allow public read access on sessions" ON sessions FOR SELECT USING (true);
CREATE POLICY "Allow public insert on registrations" ON registrations FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public read access on registrations" ON registrations FOR SELECT USING (true);
CREATE POLICY "Allow public delete on registrations" ON registrations FOR DELETE USING (true);
CREATE POLICY "Allow public update on registrations" ON registrations FOR UPDATE USING (true);
