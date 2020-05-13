module BitmaskOptions
  extend ActiveSupport::Concern

  included do
    mattr_accessor :all_options, :all_option_pairs, instance_writer: false
  end

  # This is a low level method that usually won't be used in public methods
  #http://railscasts.com/episodes/189-embedded-association
  def bitmask_options=(options)
    self.bitmask =
      (options.map(&:to_s) & all_options)
        .map { |option| 1 << all_options.index(option) }
        .reduce(:|) || 0
  end

  # This is a low level method that usually won't be used in public methods
  def bitmask_options
    all_options.select do |option|
      ( (bitmask || 0) & 1 << all_options.index(option) ).nonzero?
    end
  end

  def bitmask_values
    result = {}
    current_options = bitmask_options

    self.class.all_options.each do |option|
      result[option] = current_options.include? option
    end

    result
  end

  module ClassMethods

    #  Given all the permutations ..00, ..01, ..10, ..11 ...
    #  select only the ones that match the given option
    def positive_bitmasks_for(option)
      ref_bitmask = 1 << all_options.index(option)
      max_value = (1 << all_options.length) - 1
      (0..max_value).select{ |i| i & ref_bitmask > 0 }
    end

    #  Given all the permutations ..00, ..01, ..10, ..11 ...
    #  select only the ones that DON'T match the given option
    def negative_bitmasks_for(option)
      ref_bitmask = 1 << all_options.index(option)
      max_value = (1 << all_options.length) - 1
      (0..max_value).select{ |i| i & ref_bitmask == 0 }
    end

    # This is the macro used to initialize the model with bitmask attributes
    # For example, in Class User we have:
    #
    #   has_bitmask_options [
    #     ['accepts_email',   'Aceita receber SMS'],
    #     ['accepts_sms',     'Aceita receber e-mails'],
    #     ...
    #   ]
    def has_bitmask_options(all_option_pairs)
      # Class parameters
      self.all_option_pairs = all_option_pairs
      self.all_options = all_option_pairs.map{ |o| o[0] }

      all_options.each do |option|

        # boolean getters
        define_method(option)       { self.bitmask_options.include? option }
        define_method("#{option}?") { self.bitmask_options.include? option }

        # boolean setters - assign to true/false
        define_method("#{option}=") do |active|
          change_mask = 1 << all_options.index(option)
          self.bitmask =
            if active.to_bool
              (self.bitmask || 0) | change_mask
            else
              (self.bitmask || 0) & (~change_mask)
            end
        end

        # Convenience method - bang setter - assign to true then save!
        define_method("#{option}!") do
          send("#{option}=", true)
          save!
        end

        # Query scopes -> bit 1
        scope_name =
          case option
          when /\Aaccepts_/ then option.gsub(/\Aaccepts/, 'that_accept').to_sym
          when /\Ahas_/     then option.gsub(/\Ahas/, 'with').to_sym
          when /\Afinish_/  then :"that_#{option}"
          else option.to_sym
          end
        scope scope_name, ->{ where(bitmask: positive_bitmasks_for(option)) }

        # Query scopes -> bit 0
        scope_name =
          case option
          when /\Aaccepts_/ then option.gsub(/\Aaccepts/, 'that_reject').to_sym
          when /\Ahas_/     then option.gsub(/\Ahas/, 'without').to_sym
          when /\Afinish_/  then :"that_dont_#{option}"
          else :"not_#{option}"
          end
        scope scope_name, ->{ where(bitmask: negative_bitmasks_for(option)) }

      end
    end

  end
end
