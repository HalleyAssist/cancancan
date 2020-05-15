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
        adapter.find(resource_base, id_param)
      end
    end

    def find_resource_using_find_by
      r = find_by_dynamic_finder || find_by_find_by_finder

      return r if r

      if id_param_key.kind_of?(Array)
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
      resource_base.find_by(@options[:find_by].to_sym => id_param) if resource_base.respond_to? :find_by
    end

    def id_param
      @params[id_param_key].to_s if @params[id_param_key].present?
    end

    def id_param_key
      if @options[:id_param]
        @options[:id_param]
      else
        parent? ? :"#{name}_id" : :id
      end
    end
  end
end
