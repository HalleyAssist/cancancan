# frozen_string_literal: true

module CanCan
  module ControllerResourceFinder
    protected

    def find_resource
      if @options[:singleton] && parent_resource.respond_to?(name)
        parent_resource.send(name)
      elsif @options[:find_by]
        find_resource_using_find_by
      else
        find_resource_by_id
      end
    end

    def find_resource_by_id
      if id_param_key.is_a? Array
        for ind_id_key in id_param_key
          if @params[ind_id_key].present?
            v = @params[ind_id_key].to_s
            v = adapter.find(resource_base, v)
            return v if v
          end
        end
      else
        return adapter.find(resource_base, id_param)
      end
    end

    def find_resource_using_find_by
      r = find_by_dynamic_finder || find_by_find_by_finder

      return r if r

      if id_param_key.is_a? Array
        for ind_id_key in id_param_key
          if @params[ind_id_key].present?
            v = @params[ind_id_key].to_s
            v = resource_base.send(@options[:find_by], v)
            return v if v
          end
        end
      else
        return resource_base.send(@options[:find_by], id_param)
      end
    end

    def find_by_dynamic_finder
      method_name = "find_by_#{@options[:find_by]}!"
      resource_base.send(method_name, id_param) if resource_base.respond_to? method_name
    end

    def find_by_find_by_finder
      return unless resource_base.respond_to? :find_by
      if id_param_key.is_a? Array
        for ind_id_key in id_param_key
          if @params[ind_id_key].present?
            v = @params[ind_id_key].to_s
            v = resource_base.find_by(@options[:find_by].to_sym => v) 
            return v if v
          end
        end
      else
        return resource_base.find_by(@options[:find_by].to_sym => id_param) 
      end
      
    end

    def id_param
      l_key = id_param_key
      if l_key.is_a? Array
        for ind_id_key in l_key
          return @params[ind_id_key].to_s if @params[ind_id_key].present?
        end
      else
        return @params[id_param_key].to_s if @params[id_param_key].present?
      end
    end

    def id_param_key
      if @options[:id_param].present?
        @options[:id_param]
      else
        parent? ? :"#{name}_id" : :id
      end
    end
  end
end
