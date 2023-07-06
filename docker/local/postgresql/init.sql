-- Create a table
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INTEGER
);

-- Insert some data into the table
INSERT INTO employees (name, age)
VALUES
    ('John Doe', 30),
    ('Jane Smith', 25),
    ('Bob Johnson', 35);
