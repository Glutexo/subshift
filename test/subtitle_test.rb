require 'test/unit'
require 'subtitle'

class SubtitleTest < Test::Unit::TestCase
  FIXTURE = <<-EOS
1
02:26:23,670 --> 02:26:26,138
"Multiline"
Subtitle Fixture.
  EOS

  def setup
    @subtitle = Subtitle.new FIXTURE

    hours = 2
    minutes = hours * 60 + 26
    seconds = minutes * 60 + 23.670
    @begin = seconds

    hours = 2
    minutes = hours * 60 + 26
    seconds = minutes * 60 + 26.138
    @end = seconds
  end


  def test_body_is_extracted
    assert_equal "\"Multiline\"\nSubtitle Fixture.", @subtitle.body
  end

  def test_begin_time_is_extracted
    subtitle_begin = @subtitle.begin
    assert subtitle_begin.is_a? Duration

    assert_equal @begin, subtitle_begin
  end

  def test_end_time_is_extracted
    subtitle_end = @subtitle.end
    assert subtitle_end.is_a? Duration

    assert_equal @end, subtitle_end
  end

  def test_can_be_initialized_by_hash
    hash = {
        body: "TEST BODY",
        begin: 123,
        end: 456
    }
    subtitle = Subtitle.new hash

    assert_equal hash[:body], subtitle.body
    assert_equal hash[:begin], subtitle.begin
    assert_equal hash[:end], subtitle.end
  end

  def test_can_be_shifted_in_place
    shift = 12.345
    @subtitle.shift! shift

    assert_equal @begin + shift, @subtitle.begin
    assert_equal @end + shift, @subtitle.end
  end

  def test_can_be_shifted
    shift = 12.345
    subtitle = @subtitle.shift shift

    assert_equal @begin + shift, subtitle.begin
    assert_equal @end + shift, subtitle.end
  end

  def test_can_be_shifted_by_plus
    shift = 12.345

    @subtitle += shift

    assert_equal @begin + shift, @subtitle.begin
    assert_equal @end + shift, @subtitle.end
  end

  def test_can_be_shifted_by_minus
    shift = 12.345

    @subtitle -= shift

    assert_equal @begin - shift, @subtitle.begin
    assert_equal @end - shift, @subtitle.end
  end

end