# frozen_string_literal: true

require_relative 'conditions_matcher.rb'
module CanCan
  class RulesCompressor
    attr_reader :initial_rules, :rules_collapsed

    def initialize(rules)
      @initial_rules = rules
      @rules_collapsed = compress(@initial_rules)
    end

    def compress(array)
      array = simplify(array)
      idx = array.rindex(&:catch_all?)
      return array unless idx

      value = array[idx]
      array[idx..-1]
        .drop_while { |n| n.base_behavior == value.base_behavior }
        .tap { |a| a.unshift(value) unless value.cannot_catch_all? }
    end

    def simplify(rules)
      seen = Set.new

      # If we have a bunch of of rules with conditions on the same key, we can simplify them
      # to a single rule with an array of values
      # e.g contact_id = 1, contact_id = [2, 3] => contact_id = [1, 2, 3]
      potentially_simplify_singular = rules.size > 1 && rules.all? do |rule|
        if rule.conditions.is_a?(Hash)
          rule.conditions.size == 1
        else
          false
        end
      end

      if potentially_simplify_singular
        potentially_simplify_singular = rules.map do |rule|
          rule.conditions.keys.first
        end.uniq
        if potentially_simplify_singular.size == 1
          new_valid_values = rules.map do |rule|
            r = rule.conditions.values

            if r.is_a?(Array)
              r
            else
              [r]
            end
          end.flatten.uniq

          h = {}
          h[potentially_simplify_singular.first] = new_valid_values
          rules.last.conditions = h
          return [rules.last]
        end
      end

      # If we have A OR (!A AND anything ), then we can simplify to A OR anything
      # If we have A OR (A OR anything ), then we can simplify to A OR anything
      # If we have !A AND (A OR something), then we can simplify it to !A AND something
      # If we have !A AND (!A AND something), then we can simplify it to !A AND something
      #
      # So as soon as we see a condition that is the same as the previous one,
      # we can skip it, no matter of the base_behavior
      rules.reverse_each.filter_map do |rule|
        next if seen.include?(rule.conditions)

        seen.add(rule.conditions)
        rule
      end.reverse
    end
  end
end
