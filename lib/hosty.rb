require 'aws-sdk'
require 'yaml'

class Hosty
  VERSION = "0.0.1"

  class InstanceNotFound < StandardError; end

  class << self
    def instances_of_type( env, type )
      instances = instances_of_env(env)
      return nil unless instances
      instances.select do |instances|
        instances[:types].include?( type )
      end
    end

    def instances_of_env( env )
      @@instances[env.to_sym]
    end

    def env_of_instance( name )
      env = @@instances.keys.find { |an_env| find_instance_by_name( an_env, name ) }
      raise Hosty::InstanceNotFound if env.nil?
      env
    end

    def lookup( name )
      env = env_of_instance( name )
      instance = find_instance_by_name( env, name )

      if !@@config.is_a?(Proc)
        raise NotImplementedError.new( "Hosty config lambda is missing" )
      end

      # look it up
      ec2 = Aws::EC2::Client.new(
        region: instance[:region] || 'us-east-1',
        credentials: Aws::Credentials.new( *@@config.(instance[:env]) )
      )
      ec2.describe_instances( instance_ids: [instance[:id]] )
        .reservations.first
        .instances.first
    end

    #
    # config methods
    #

    def instance( info )
      env = info[:env] = info[:env].try(:to_sym) || :production
      @@instances ||= {}
      @@instances[env] ||= []
      @@instances[env] << info
    end

    def config( &block )
      @@config = block
    end

    #
    # internal methods
    #

    private

    def find_instance_by_name( env, name )
      @@instances[env].find { |instance| instance[:name] == name }
    end
  end
end
