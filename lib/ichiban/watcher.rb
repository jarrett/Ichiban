module Ichiban
  class Watcher        
    def initialize(options = {})
      @options = {
        :latency => 0.5
      }.merge(options)
    end
    
    def start
      @loader = Ichiban::Loader.new
      
      Ichiban.logger.out 'Starting watcher'
      begin
        @listener = Listen.to(
          File.join(Ichiban.project_root, 'html'),
          File.join(Ichiban.project_root, 'layouts'),
          File.join(Ichiban.project_root, 'assets'),
          File.join(Ichiban.project_root, 'models'),
          File.join(Ichiban.project_root, 'helpers'),
          File.join(Ichiban.project_root, 'scripts'),
          File.join(Ichiban.project_root, 'data'),
          File.join(Ichiban.project_root, 'webserver'),
          ignore: /.listen_test$/,
          latency: @options[:latency]
        ) do |modified, added, deleted|
          (modified + added).uniq.each do |path|
            if file = Ichiban::ProjectFile.from_abs(path)
              @loader.change(file) # Tell the Loader that this file has changed
              begin
                file.update
              rescue => exc
                Ichiban.logger.exception(exc)
              end
            end
          end                    
          deleted.each do |path|
            Ichiban::Deleter.new.delete_dest(path)
          end
          (modified + added + deleted).uniq.each do |path|
            begin
              Ichiban::Dependencies.propagate(path)
            rescue => exc
              Ichiban.logger.exception(exc)
            end
          end
        end
        @listener.start
      rescue Interrupt
        stop
        exit 0
      end
    end
    
    def stop
      if @listener
        Ichiban.logger.out "Stopping watcher"
        @listener.stop
        @listener = nil
      end
    end
  end
end