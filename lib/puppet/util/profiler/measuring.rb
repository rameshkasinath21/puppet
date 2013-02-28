class Puppet::Util::Profiler::Measuring
  def initialize(logger, identifier)
    @logger = logger
    @identifier = identifier
    @sequence = Sequence.new
  end

  def profile(description, &block)
    retval = nil
    @sequence.next
    @sequence.down
    time = Benchmark.measure { retval = yield }
    @sequence.up
    @logger.debug("#{@sequence} [#{@identifier}] #{description} in #{format('%0.4f', time.real)} seconds")
    retval
  end

  class Sequence
    INITIAL = 0

    def initialize
      @elements = [INITIAL]
    end

    def next
      @elements[-1] += 1
    end

    def down
      @elements << INITIAL
    end

    def up
      @elements.pop
    end

    def to_s
      @elements.join('.')
    end
  end
end

