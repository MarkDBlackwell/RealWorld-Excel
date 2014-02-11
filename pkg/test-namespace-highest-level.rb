require 'test/unit'

module Strange #Namespace.

  class Try

    def initialize
    end

    def value
      'Top-level Strange'
    end

  end #class

end #module
#-------------------
module Usual #Namespace.

  module Strange #Another namespace. Is this the one selected?

    class Try

      def initialize
      end

      def value
        'Strange within Usual'
      end

    end #class

  end #module

end #module
#-------------------
module Usual #Namespace.

  class See
    include Strange

    def initialize
    end

    def value
      space=Strange
      space::Try.new.value
    end

  end #class

end #module
#-------------------
module Usual #Namespace.

  class Test < Test::Unit::TestCase

    def test_namespace_highest_level
      assert_equal('Strange within Usual',Usual::See.new.value)
    end

  end #class

end #module
