class AddFuzzywuzy < ActiveRecord::Migration[6.0]
  def change
    enable_extension :fuzzystrmatch

    execute(<<~SQL)
      CREATE OR REPLACE FUNCTION ratio(l text, r text) RETURNS int
        LANGUAGE plpgsql IMMUTABLE
          AS $$
            DECLARE
              diff      int;  -- levenshtein编辑距离
              l_len     int := length(l);
              r_len     int := length(r);
              short_len int;
              long_len  int;
              match_len int;
              result    int;
            BEGIN
              IF (l IS NULL) OR (r IS NULL) OR (l = '') OR (r = '') THEN
                result := 0;
              ELSE
                SELECT levenshtein(l, r)      INTO diff;
                SELECT GREATEST(l_len, r_len) INTO long_len;
                SELECT LEAST(l_len, r_len)    INTO short_len;
                -- match长度为：最长字符串减去编辑距离
                match_len := long_len - diff;
                -- 基于fuzzywuzzy公式
                -- Return a measure of the sequences’ similarity as a float in the range [0, 100].
                -- Where T is the total number of elements in both sequences, and M is the number of matches, this is 2.0*M / T. 
                -- Note that this is 100 if the sequences are identical, and 0 if they have nothing in common.
                -- https://docs.python.org/3/library/difflib.html#difflib.SequenceMatcher.ratio
                -- https://github.com/seatgeek/fuzzywuzzy
                result := ((2.0 * match_len * 100) / (long_len + short_len));
              END IF;
              RETURN(result);
            END;
          $$;
    SQL
  end
end
