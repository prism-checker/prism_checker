# frozen_string_literal: true

require_relative '../support/pages/performance'
require 'prism_checker'

# rubocop:disable RSpec/ExampleLength
# rubocop:disable RSpec/MultipleExpectations

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { Performance.new }

  it 'tests performance' do
    repeat = 3
    n = 3
    regular_slow_test_time = 0
    regular_fast_test_time = 0
    test_time = 0

    # ------------------------------------------------------------------------------------------------------------------
    1.upto(repeat) do
      page.load

      start_time = Time.now

      expect(page.header.text).to eq('Performance test')
      expect(page).to have_ol1

      expect(page.ol1).to be_visible
      expect(page.ol1.li1.size).to eq(n)

      0.upto(n - 1) do |i|
        expect(page.ol1.li1[i].ul2).to be_visible
        expect(page.ol1.li1[i].ul2.li2.size).to eq(n)

        0.upto(n - 1) do |j|
          expect(page.ol1.li1[i].ul2.li2[j]).to be_visible
          expect(page.ol1.li1[i].ul2.li2[j].div3.size).to eq(n)

          0.upto(n - 1) do |k|
            expect(page.ol1.li1[i].ul2.li2[j].div3[k].span3).to be_visible
            expect(page.ol1.li1[i].ul2.li2[j].div3[k].span3.text).to eq("#{i}.#{j}.#{k}")

            expect(page.ol1.li1[i].ul2.li2[j].div3[k].p3).to be_visible
            expect(page.ol1.li1[i].ul2.li2[j].div3[k].p3.text).to eq('Foo bar')
          end
        end
      end

      regular_slow_test_time += Time.now - start_time
    end

    # ------------------------------------------------------------------------------------------------------------------
    1.upto(repeat) do
      page.load

      start_time = Time.now

      expect(page.ol1).to be_visible
      expect(page.ol1.li1.size).to eq(n)

      0.upto(n - 1) do |i|
        li1 = page.ol1.li1[i]
        expect(li1.ul2).to be_visible
        expect(li1.ul2.li2.size).to eq(n)

        0.upto(n - 1) do |j|
          li2 = li1.ul2.li2[j]
          expect(li2).to be_visible
          expect(li2.div3.size).to eq(3)

          0.upto(n - 1) do |k|
            div3 = li2.div3[k]
            expect(div3.span3).to be_visible
            expect(div3.span3.text).to eq("#{i}.#{j}.#{k}")

            expect(div3.p3).to be_visible
            expect(div3.p3.text).to eq('Foo bar')
          end
        end
      end

      regular_fast_test_time += Time.now - start_time
    end

    # ------------------------------------------------------------------------------------------------------------------

    1.upto(repeat) do
      page.load

      start_time = Time.now

      expect(checker.check(page, {
                             ol1: {
                               li1: [
                                 {
                                   ul2: {
                                     li2: [
                                       {
                                         div3: [
                                           { span3: '0.0.0', p3: 'Foo bar' },
                                           { span3: '0.0.1', p3: 'Foo bar' },
                                           { span3: '0.0.2', p3: 'Foo bar' }
                                         ]
                                       },
                                       {
                                         div3: [
                                           { span3: '0.1.0', p3: 'Foo bar' },
                                           { span3: '0.1.1', p3: 'Foo bar' },
                                           { span3: '0.1.2', p3: 'Foo bar' }
                                         ]
                                       },
                                       {
                                         div3: [
                                           { span3: '0.2.0', p3: 'Foo bar' },
                                           { span3: '0.2.1', p3: 'Foo bar' },
                                           { span3: '0.2.2', p3: 'Foo bar' }
                                         ]
                                       }
                                     ]
                                   }
                                 },
                                 {
                                   ul2: {
                                     li2: [
                                       {
                                         div3: [
                                           { span3: '1.0.0', p3: 'Foo bar' },
                                           { span3: '1.0.1', p3: 'Foo bar' },
                                           { span3: '1.0.2', p3: 'Foo bar' }
                                         ]
                                       },
                                       {
                                         div3: [
                                           { span3: '1.1.0', p3: 'Foo bar' },
                                           { span3: '1.1.1', p3: 'Foo bar' },
                                           { span3: '1.1.2', p3: 'Foo bar' }
                                         ]
                                       },
                                       {
                                         div3: [
                                           { span3: '1.2.0', p3: 'Foo bar' },
                                           { span3: '1.2.1', p3: 'Foo bar' },
                                           { span3: '1.2.2', p3: 'Foo bar' }
                                         ]
                                       }
                                     ]
                                   }
                                 },
                                 {
                                   ul2: {
                                     li2: [
                                       {
                                         div3: [
                                           { span3: '2.0.0', p3: 'Foo bar' },
                                           { span3: '2.0.1', p3: 'Foo bar' },
                                           { span3: '2.0.2', p3: 'Foo bar' }
                                         ]
                                       },
                                       {
                                         div3: [
                                           { span3: '2.1.0', p3: 'Foo bar' },
                                           { span3: '2.1.1', p3: 'Foo bar' },
                                           { span3: '2.1.2', p3: 'Foo bar' }
                                         ]
                                       },
                                       {
                                         div3: [
                                           { span3: '2.2.0', p3: 'Foo bar' },
                                           { span3: '2.2.1', p3: 'Foo bar' },
                                           { span3: '2.2.2', p3: 'Foo bar' }
                                         ]
                                       }
                                     ]
                                   }
                                 }
                               ]
                             }
                           })).to eq true

      test_time += Time.now - start_time
    end

    expect(regular_slow_test_time / test_time).to be > 1.9
    expect(regular_fast_test_time / test_time).to be > 0.8
  end
end

# rubocop:enable RSpec/ExampleLength
# rubocop:enable RSpec/MultipleExpectations
