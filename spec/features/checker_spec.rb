# frozen_string_literal: true

require_relative '../support/pages/blog'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { Blog.new }

  describe '.check' do
    context 'when page is valid' do
      context 'when page contains section with array of sections inside' do
        before do
          page.load
        end

        context 'when expectation is defined as string' do
          it 'result is success' do
            expect(checker.check(page, 'Lorem ipsum')).to eq true
          end
        end

        context 'when expectation is defined as regexp' do
          it 'result is success' do
            expect(checker.check(page, /My Blog.*Lorem ipsum/)).to eq true
          end
        end

        context 'when expectation is defined as hash' do
          it 'result is success' do
            expect(checker.check(page, {
              header: 'My Blog',
              posts: /Posts/
            })).to eq true
          end
        end

        context 'when expectation is defined as hash and contains array as sections description' do
          it 'result is success' do
            checker.check(page, {
              posts: {
                header: 'Posts',
                root_element: {
                  class: 'posts-holder'
                },
                post: [
                  {
                    title: 'Lorem ipsum'
                  },
                  /Vestibulum ante/
                ]
              }
            })

            puts checker.report
          end
        end

        context 'when expectation is defined as hash and contains regexp as sections description' do
          it 'result is success' do
            expect(checker.check(page, {
              posts: {
                header: 'Posts',
                post: /.*Lorem ipsum.*Vestibulum ante.*/
              }
            })).to eq true
          end
        end
      end

      context 'when page contains 0 sections' do
        before do
          page.load(config: 'zero-posts')
        end

        context 'when expectation contains empty array as sections description' do
          it 'result is success' do
            expect(checker.check(page, {posts: {post: []}})).to eq true
          end
        end
      end

      context 'when page contains sections' do
        before do
          page.load
        end

        context 'when expectation contains description of section method' do
          it 'result is success' do
            expect(checker.check(page, post_dates: '2020-10-11 2020-10-11')).to eq true
          end
        end
      end
    end

    context 'when page is invalid' do
      context 'when page not contains required text' do
        before do
          page.load
        end

        context 'when expectation is defined as string' do
          let(:expectation) { 'Foo' }

          it 'result is failure' do
            expect(checker.check(page, expectation)).to eq false
          end

          it 'report contains description' do
            checker.check(page, expectation)
            expect(checker.report).to match /Fail: Expected 'My Blog.* to include 'Foo'/
          end
        end

        context 'when expectation is defined as regexp' do
          let(:expectation) { /Foo/ }

          it 'result is failure' do
            expect(checker.check(page, expectation)).to eq false
          end

          it 'report contains description' do
            checker.check(page, expectation)
            expect(checker.report).to match /Fail: Expected 'My Blog.* to match.*Foo/
          end
        end
      end

      context 'when page contains wrong text in the child section' do
        before do
          page.load
        end

        context 'when expectation is defined as hash with child description' do
          let(:expectation) do
            {
              header: 'My Blog',
              posts: {
                header: 'My posts'
              }
            }
          end

          it 'result is failure' do
            expect(checker.check(page, expectation)).to eq false
          end

          it 'report contains description' do
            checker.check(page, expectation)
            expect(checker.report).to eq <<~REPORT.strip
              {
                header: Ok
                posts: {
                  header: Fail: Expected 'Posts' to include 'My posts'
                }
              }
            REPORT
          end
        end
      end

      context 'when page not contains child component' do
        before do
          page.load(config: 'no-posts')
        end

        context 'when expectation contains hash with string' do
          it 'raises error with report as message' do
            expected_report = <<~REPORT.strip
              {
                header: Ok
                posts: Error: Unable to find css ".posts-holder"
              }
              Unable to find css ".posts-holder"
            REPORT

            expect { checker.check(page, {header: 'My Blog', posts: {header: 'Posts'}}) }
              .to raise_error(Capybara::ElementNotFound)
              .with_message(Regexp.new(expected_report))
          end
        end
      end

      context 'when page contains wrong number of child sections' do
        before do
          page.load
        end

        context 'when expectation is defined as hash with array of sections' do
          let(:expectation) do
            {
              header: 'My Blog',
              posts: {
                post: [{}, {}, {}],
                header: 'Posts'
              }
            }
          end

          it 'result is failure' do
            expect(checker.check(page, expectation)).to eq false
          end

          it 'report contains description' do
            checker.check(page, expectation)
            # puts checker.report
            expect(checker.report).to eq <<~REPORT.strip
              {
                header: Ok
                posts: {
                  post: Fail: Wrong elements count
                              Actual: 2
                              Expected: 3
                  header: Not checked
                }
              }
            REPORT
          end
        end
      end

      context 'when page contains wrong section inside array of sections' do
        before do
          page.load
        end

        context 'when expectation is defined as hash with array of sections' do
          let(:expectation) do
            {
              header: 'My Blog',
              posts: {
                post: [
                  {title: 'Lorem ipsum'},
                  {title: 'Ut eget justo erat'}
                ],
                header: 'Posts'
              }
            }
          end

          it 'result is failure' do
            expect(checker.check(page, expectation)).to eq false
          end

          it 'report contains description' do
            checker.check(page, expectation)
            expect(checker.report).to eq <<~REPORT.strip
              {
                header: Ok
                posts: {
                  post: [
                    {
                      title: Ok
                    }
                    {
                      title: Fail: Expected 'Vestibulum ante' to include 'Ut eget justo erat'
                    }
                  ]
                  header: Not checked
                }
              }
            REPORT
          end
        end
      end

      context 'when page contains invisible section' do
        before do
          page.load(config: 'invisible-posts')
        end

        context 'when expectation is defined as hash' do
          let(:expectation) do
            {
              header: 'My Blog',
              posts: {
                header: 'My posts'
              }
            }
          end

          it 'result is failure' do
            expect(checker.check(page, expectation)).to eq false
          end

          it 'report contains description' do
            checker.check(page, expectation)
            expect(checker.report).to eq <<~REPORT.strip
              {
                header: Ok
                posts: Fail: Element is not visible
              }
            REPORT
          end
        end

        context 'when expectation of invisible section is defined as empty hash' do
          let(:expectation) do
            {
              header: 'My Blog',
              posts: {}
            }
          end

          it 'result is failure' do
            expect(checker.check(page, expectation)).to eq false
          end

          it 'report contains description' do
            checker.check(page, expectation)
            expect(checker.report).to eq <<~REPORT.strip
              {
                header: Ok
                posts: Fail: Element is not visible
              }
            REPORT
          end
        end

        context 'when expectation of invisible section is defined as string' do
          let(:expectation) do
            {
              header: 'My Blog',
              posts: 'Posts'
            }
          end

          it 'result is failure' do
            expect(checker.check(page, expectation)).to eq false
          end

          it 'report contains description' do
            checker.check(page, expectation)
            expect(checker.report).to eq <<~REPORT.strip
              {
                header: Ok
                posts: Fail: Element is not visible
              }
            REPORT
          end
        end
      end
    end
  end
end
