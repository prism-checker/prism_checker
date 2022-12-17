# frozen_string_literal: true

require_relative '../support/pages/blog'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  let(:page) { Blog.new }
  subject(:checker) { described_class.new }

  describe '.check' do
    before do
      page.load
    end


    #Error: Can not check element of type Blog with expectation:
    #               ["Foo"]
    #
    #        Can not check element of type Blog with expectation:
    #        ["Foo"]

    context 'when expectation is invalid' do
      context 'when root expectation is defined as array' do
        it 'result is error' do
          expected_report = <<~REPORT.strip
          Error: Can not check element of type Blog with expectation:
                 ["Foo"]
          Can not check element of type Blog with expectation:
          ["Foo"]
          REPORT

          # begin
          #   checker.check(page, ['Foo'])
          #   puts checker.report
          # rescue => e
          #   puts checker.report
          #   puts '==='
          #   puts e.message
          #
          #   expect(e.message).to eq(expected_report)
          # end

          expect { checker.check(page, ['Foo']) }
            .to raise_error(PrismChecker::Node::BadExpectation)
            .with_message(expected_report)
        end
      end

      context 'when root expectation is defined as number' do
        it 'result is error' do
          expected_report = <<~REPORT.strip
          Error: Can not check element of type Blog with expectation:
                 123
          Can not check element of type Blog with expectation:
          123
          REPORT

          expect { checker.check(page, 123) }
            .to raise_error(PrismChecker::Node::BadExpectation)
            .with_message(expected_report)
        end
      end

      context 'when expectation is defined as hash with symbol as key and number as value' do
        it 'result is error' do
          expected_report = <<~REPORT.strip
          {
            posts: Error: Can not check element of type SitePrism::Section with expectation:
                          123
          }
          Can not check element of type SitePrism::Section with expectation:
          123
          REPORT

          expect { checker.check(page, {posts: 123}) }
            .to raise_error(PrismChecker::Node::BadExpectation)
            .with_message(expected_report)
        end
      end

      context 'when expectation is defined as hash with key not matching any section' do
        it 'result is error' do
          expected_report = <<~REPORT.strip
          {
            foo: Error: undefined method `foo' for #<Blog.*
                        Did you mean?.*
          }
          undefined method `foo' for #<Blog.*
          Did you mean?.*
          REPORT

          expect { checker.check(page, {foo: 'bar'}) }
            .to raise_error(NoMethodError)
            .with_message(Regexp.new(expected_report, Regexp::MULTILINE))
        end
      end

      context 'when expectation is defined as hash with number as key' do
        it 'result is error' do
          expected_report = <<~REPORT.strip
          {
            posts: {
              123: Error: 123 is not a symbol nor a string
            }
          }
          123 is not a symbol nor a string
          REPORT

          expect { checker.check(page, posts: {123 => {}}) }
            .to raise_error(TypeError)
            .with_message(expected_report)
        end
      end

      context 'when expectation for sections (array) is defined as hash' do
        it 'result is error' do
          expected_report = <<~REPORT.strip
          {
            posts: {
              post: Error: Can not check element of type Array with expectation:
                           {}
            }
          }
          Can not check element of type Array with expectation:
          {}
          REPORT

          expect { checker.check(page, {posts: {post: {}}}) }
            .to raise_error(PrismChecker::Node::BadExpectation)
            .with_message(expected_report)
        end
      end

      context 'when expectation for section is defined as array' do
        it 'result is error' do
          expected_report = <<~REPORT.strip
          {
            posts: Error: Can not check element of type SitePrism::Section with expectation:
                          []
          }
          Can not check element of type SitePrism::Section with expectation:
          []
          REPORT

          # begin
          #   checker.check(page, posts: [])
          #   puts checker.report
          # rescue => e
          #   puts checker.report
          #   puts '==='
          #   puts e.message
          #   # expect("Error: foo: Error: undefined method `foo' for #<Blog.*").to
          # end

          expect { checker.check(page, posts: []) }
            .to raise_error(PrismChecker::Node::BadExpectation)
            .with_message(expected_report)
        end
      end

      # context 'when root expectation is defined as nested array' do
      #   it 'result is error' do
      #     # checker.check(page, 123)
      #     # puts checker.report
      #     expect { checker.check(page, 123) }
      #       .to raise_error(Node::BadExpectation)
      #             .with_message <<~REPORT.strip
      #                     Error: Wrong expectation type: Integer. Expected Hash, String, Regexp
      #                            123
      #     REPORT
      #   end
      # end

      # context 'when page not contains required text' do
      #   before do
      #     page.load
      #   end
      #
      #   context 'when expectation is defined as string' do
      #     let(:expectation) { 'Foo' }
      #
      #     it 'result is failure' do
      #       expect(checker.check(page, expectation)).to eq false
      #     end
      #
      #     it 'report contains description' do
      #       checker.check(page, expectation)
      #       expect(checker.report).to match /Fail: Expected 'My Blog.* to include 'Foo'/
      #     end
      #   end
      #
      #   context 'when expectation is defined as regexp' do
      #     let(:expectation) { /Foo/ }
      #
      #     it 'result is failure' do
      #       expect(checker.check(page, expectation)).to eq false
      #     end
      #
      #     it 'report contains description' do
      #       checker.check(page, expectation)
      #       expect(checker.report).to match /Fail: Expected 'My Blog.* to match.*Foo/
      #     end
      #   end
      # end

      # context 'when page contains wrong text in the child section' do
      #   before do
      #     page.load
      #   end
      #
      #   context 'when expectation is defined as hash with child description' do
      #     let(:expectation) do
      #       {
      #         header: 'My Blog',
      #         posts: {
      #           header: 'My posts'
      #         }
      #       }
      #     end
      #
      #     it 'result is failure' do
      #       expect(checker.check(page, expectation)).to eq false
      #     end
      #
      #     it 'report contains description' do
      #       checker.check(page, expectation)
      #       expect(checker.report).to eq <<~REPORT.strip
      #       {
      #         header: Ok
      #         posts: {
      #           header: Fail: Expected 'Posts' to include 'My posts'
      #         }
      #       }
      #       REPORT
      #     end
      #   end
      # end

      # context 'when page not contains child component' do
      #   before do
      #     page.load(config: 'no-posts')
      #   end
      #
      #   context 'when expectation contains hash with string' do
      #     it 'raises error with report as message' do
      #       expected_report = <<~REPORT.strip
      #       {
      #         header: Ok
      #         posts: Error: Unable to find css ".posts-holder"
      #       }
      #       Unable to find css ".posts-holder"
      #       REPORT
      #
      #       expect { checker.check(page, {header: 'My Blog', posts: {header: 'Posts'}}) }
      #         .to raise_error(Capybara::ElementNotFound)
      #         .with_message(Regexp.new(expected_report))
      #     end
      #   end
      # end

      # context 'when page contains wrong number of child sections' do
      #   before do
      #     page.load
      #   end
      #
      #   context 'when expectation is defined as hash with array of sections' do
      #     let(:expectation) do
      #       {
      #         header: 'My Blog',
      #         posts: {
      #           post: [{}, {}, {}],
      #           header: 'Posts'
      #         }
      #       }
      #     end
      #
      #     it 'result is failure' do
      #       expect(checker.check(page, expectation)).to eq false
      #     end
      #
      #     it 'report contains description' do
      #       checker.check(page, expectation)
      #       expect(checker.report).to eq <<~REPORT.strip
      #       {
      #         header: Ok
      #         posts: {
      #           post: Fail: Wrong elements count
      #                 Actual: 2
      #                 Expected: 3
      #           header: Not checked
      #         }
      #       }
      #       REPORT
      #     end
      #   end
      # end

      # context 'when page contains wrong section inside array of sections' do
      #   before do
      #     page.load
      #   end
      #
      #   context 'when expectation is defined as hash with array of sections' do
      #     let(:expectation) do
      #       {
      #         header: 'My Blog',
      #         posts: {
      #           post: [
      #             {title: 'Lorem ipsum'},
      #             {title: 'Ut eget justo erat'}
      #           ],
      #           header: 'Posts'
      #         }
      #       }
      #     end
      #
      #     it 'result is failure' do
      #       expect(checker.check(page, expectation)).to eq false
      #     end
      #
      #     it 'report contains description' do
      #       checker.check(page, expectation)
      #       expect(checker.report).to eq <<~REPORT.strip
      #       {
      #         header: Ok
      #         posts: {
      #           post: [
      #             {
      #               title: Ok
      #             }
      #             {
      #               title: Fail: Expected 'Vestibulum ante' to include 'Ut eget justo erat'
      #             }
      #           ]
      #           header: Not checked
      #         }
      #       }
      #       REPORT
      #     end
      #   end
      # end

      # context 'when page contains invisible section' do
      #   before do
      #     page.load(config: 'invisible-posts')
      #   end
      #
      #   context 'when expectation is defined as hash' do
      #     let(:expectation) do
      #       {
      #         header: 'My Blog',
      #         posts: {
      #           header: 'My posts'
      #         }
      #       }
      #     end
      #
      #     it 'result is failure' do
      #       expect(checker.check(page, expectation)).to eq false
      #     end
      #
      #     it 'report contains description' do
      #       checker.check(page, expectation)
      #       expect(checker.report).to eq <<~REPORT.strip
      #       {
      #         header: Ok
      #         posts: Fail: Element is not visible
      #       }
      #       REPORT
      #     end
      #   end
      #
      #   context 'when expectation of invisible section is defined as empty hash' do
      #     let(:expectation) do
      #       {
      #         header: 'My Blog',
      #         posts: {}
      #       }
      #     end
      #
      #     it 'result is failure' do
      #       expect(checker.check(page, expectation)).to eq false
      #     end
      #
      #     it 'report contains description' do
      #       checker.check(page, expectation)
      #       expect(checker.report).to eq <<~REPORT.strip
      #       {
      #         header: Ok
      #         posts: Fail: Element is not visible
      #       }
      #       REPORT
      #     end
      #   end
      #
      #   context 'when expectation of invisible section is defined as string' do
      #     let(:expectation) do
      #       {
      #         header: 'My Blog',
      #         posts: 'Posts'
      #       }
      #     end
      #
      #     it 'result is failure' do
      #       expect(checker.check(page, expectation)).to eq false
      #     end
      #
      #     it 'report contains description' do
      #       checker.check(page, expectation)
      #       expect(checker.report).to eq <<~REPORT.strip
      #       {
      #         header: Ok
      #         posts: Fail: Element is not visible
      #       }
      #       REPORT
      #     end
      #   end
      # end
    end
  end
end
