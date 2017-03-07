vowels = (('a'..'z').each_with_index.map {|key, value| {key => (value + 1)} if key =~ /[aeiouy]/}).compact

