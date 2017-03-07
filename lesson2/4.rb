regexp = /[aeiouy]/
vowels = {}
('a'..'z').each_with_index { |key, value| vowels[key] = value + 1 if key =~ regexp }
