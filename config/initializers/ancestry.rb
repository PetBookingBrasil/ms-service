module Ancestry
  # Setting the pattern this way silences the warning when
  # we overwrite a constant
  # allow uuid
  send :remove_const, :ANCESTRY_PATTERN
  const_set :ANCESTRY_PATTERN, /\A[\w\-]+(\/[\w\-]+)*\z/
end
