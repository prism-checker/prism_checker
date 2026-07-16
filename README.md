![ci workflow](https://github.com/prism-checker/prism_checker/actions/workflows/ci-main.yml/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/c497733cb53175decd0f/maintainability)](https://codeclimate.com/github/prism-checker/prism_checker/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c497733cb53175decd0f/test_coverage)](https://codeclimate.com/github/prism-checker/prism_checker/test_coverage)

## Contents

- [Overview](#overview)
- [Install](#install)
- [Setup](#setup)
- [Cheat sheet](#cheat-sheet)
- [Examples](#examples)
  - [Common cases](#common-cases)
  - [HTML elements](#html-elements)
  - [Visibility](#visibility)
  - [Absence](#absence)
- [Configuration](#configuration)
  - [String comparison](#string-comparison)
  - [Colorizer](#colorizer)

## Overview

PrismChecker is an extension for rspec and minitest, built on top of the [SitePrism](https://github.com/site-prism/site_prism)
gem and using its page object model.
It allows you to write short, easy-to-read browser tests with clear error messages

Requires Ruby >= 3.3 and site_prism >= 5.0.

Let's assume your application has the following shop cart:

![Cart](doc/images/cart.png "Cart")

Corresponding SitePrism PDO::

```ruby
class Cart < SitePrism::Page
  set_url '/cart.html'

  element :header, 'h1'

  sections :cart_items, '[data-test="cart-item"]' do
    element :name, '[data-test="cart-item-name"]'
    element :image, '[data-test="cart-item-image"]'
    element :price, '[data-test="cart-item-price"]'
    element :quantity, '[data-test="cart-item-quantity"]'
    element :total, '[data-test="cart-item-total"]'
  end

  section :checkout, '[data-test="cart-checkout"]' do
    element :total, '[data-test="cart-checkout-total"]'
    element :checkout_button, '[data-test="cart-checkout-button"]'
  end
end
```

A typical test would look like this:

```ruby
describe 'Cart' do
  it 'is correct' do
    page = Cart.new
    page.load
    
    expect(page.header.text).to eq('Shopping Cart')

    expect(page.cart_items.size).to eq(2)

    expect(page.cart_items[0].visible?).to be_truthy
    expect(page.cart_items[0].name.text).to match('Cup')
    expect(page.cart_items[0].quantity.value).to match('1')
    expect(page.cart_items[0].image[:src]).to match('cup.png')
    expect(page.cart_items[0].price.text).to match('19.00')
    expect(page.cart_items[0].total.text).to match('19.00')

    expect(page.cart_items[1].visible?).to be_truthy
    expect(page.cart_items[1].name.text).to match('Cap')
    expect(page.cart_items[1].quantity.value).to match('2')
    expect(page.cart_items[1].image[:src]).to match('cap.png')
    expect(page.cart_items[1].price.text).to match('24.00')
    expect(page.cart_items[1].total.text).to match('48.00')

    expect(page.checkout.visible?).to be_truthy
    expect(page.checkout.total.text).to match('67.99')
    expect(page.checkout.checkout_button.text).to match('Checkout')
  end
end
```

Using gem prism_checker, the same test will look much cleaner and simpler:

```ruby
describe 'Cart' do
  it 'is correct' do
    page = Cart.new
    page.load

    expect(page).to be_like(
      header: 'Shopping Cart',
      cart_items: [
        {
          name: 'Cup',
          quantity: '1',
          image: 'cup.png',
          price: '19.00',
          total: '19.00'
        },
        {
          name: 'Cap',
          quantity: '2',
          image: 'cap.png',
          price: '24.00',
          total: '48.00'
        }
      ],
      checkout: {
        total: '67.00', # deliberately wrong, to show the failure report below
        checkout_button: 'Checkout'
      }
    )
  end
end

```

In case of errors, an easy-to-read message will be displayed. Every key is reported with its
own status, so the failing one is visible at a glance:

![Result](doc/images/result.png "Result")

## Install
To install PrismChecker:

### RSpec

```bash
gem install prism_checker_rspec
```
### MiniTest

```bash
gem install prism_checker_minitest
```

## Setup

PrismChecker drives the browser through SitePrism and Capybara, so a Capybara driver has to be
registered as usual. Only the last two lines are PrismChecker-specific.

### RSpec

Adds the `be_like` matcher:

```ruby
# Gemfile
gem 'prism_checker_rspec'
```
```ruby
# spec/spec_helper.rb
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'prism_checker_rspec'

Capybara.register_driver :prism_checker do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.configure do |config|
  config.default_driver = :prism_checker
  config.app_host = 'http://localhost:3000'
  # Needed so that :invisible expectations can see hidden elements
  config.ignore_hidden_elements = false
end
```
```ruby
# spec/cart_spec.rb
describe 'Cart' do
  it 'is correct' do
    page = Cart.new
    page.load

    expect(page).to be_like(header: 'Shopping Cart')
  end
end
```

### MiniTest

Adds the `assert_page_like` assertion:

```ruby
# Gemfile
gem 'prism_checker_minitest'
```
```ruby
# test/test_helper.rb
require 'minitest/autorun'
require 'capybara/minitest'
require 'site_prism'
require 'prism_checker_minitest'

# ...same Capybara.register_driver / Capybara.configure as above
```
```ruby
# test/cart_test.rb
class CartTest < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  def test_cart
    page = Cart.new
    page.load

    assert_page_like page, header: 'Shopping Cart'
  end
end
```

## Cheat sheet

What gets checked depends on the type of the expectation and on the inspected item.

| Expectation | Checked against |
|---|---|
| `'text'` | `text` of an element, section or page; `value` of an input, textarea or select; `src` of an image |
| `/regexp/` | the same values, matched as a regular expression |
| `42` | `size` of elements/sections |
| `[...]` | `size` of elements/sections, then each entry in turn |
| `{...}` | element is visible, then each key in turn |
| `true` / `false` | `checked?` of a checkbox or radio |
| `:visible` | `visible?` |
| `:invisible` | `visible?` is false |
| `:absent` | `has_no_<name>?` |
| `:absent3` | sleep 3 seconds, then `has_no_<name>?` |
| `:empty` | value is an empty string |

Inside a `{...}` expectation, keys map to Capybara methods (`text`, `value`, `checked`, `disabled`,
`readonly`, `selected`, `multiple`) or, failing that, to HTML attributes (`class`, `id`, `src`, `alt`,
`data-*`, ...).

A page or element is always checked for being loaded or visible before its value is compared,
so those assertions never need to be spelled out.

## Examples
### Common cases

Page and Page Object Model:

![Cart](doc/images/cart.png "Cart")

```ruby
class Cart < SitePrism::Page
  element :header, 'h1'

  sections :cart_items, '[data-test="cart-item"]' do
    element :name, '[data-test="cart-item-name"]'
    element :price, '[data-test="cart-item-price"]'
  end

  section :checkout, '[data-test="cart-checkout"]' do
    element :total, '[data-test="cart-checkout-total"]'
    element :checkout_button, '[data-test="cart-checkout-button"]'
  end 
end
```


#### Text check

```ruby
@page = Cart.new
page.load

expect(page).to be_like('Shopping Cart')

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.text).to match('Shopping Cart')
```


#### Element and section check

```ruby
@page = Cart.new
page.load

expect(page).to be_like(
  header: 'Shopping Cart',
  checkout: {
    total: '67.99',
    checkout_button: 'Checkout'
  }
)

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.header.visible?).to eq(true)
# expect(page.header.text).to match('Shopping Cart')
# expect(page.checkout.visible?).to eq(true)
# expect(page.checkout.total.visible?).to eq(true)
# expect(page.checkout.total.text).to match('67.99')
# expect(page.checkout.checkout_button.visible?).to eq(true)
# expect(page.checkout.checkout_button.text).to match('Checkout')
```


#### Element check

```ruby
@page = Cart.new
page.load

# page.header is inspected, not page                         

expect(page.header).to be_like('Shopping Cart')

# Same as
# expect(page.header.visible?).to eq(true)
# expect(page.header.text).to match('Shopping Cart')
```
```ruby
@page = Cart.new
page.load

# page is inspected                         

expect(page).to be_like(header: 'Shopping Cart')

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.header.visible?).to eq(true)
# expect(page.header.text).to match('Shopping Cart')
```


#### Section check

```ruby
expect(page.checkout).to be_like(
  total: '67.99',
  checkout_button: 'Checkout'
)

# Same as
# expect(page.checkout.visible?).to eq(true)
# expect(page.checkout.total.visible?).to eq(true)
# expect(page.checkout.total.text).to match('67.99')
# expect(page.checkout.checkout_button.visible?).to eq(true)
# expect(page.checkout.checkout_button.text).to match('Checkout')
```
```ruby
expect(page).to be_like(
  checkout: {
    total: '67.99',
    checkout_button: 'Checkout'
  }
)

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.checkout.visible?).to eq(true)
# expect(page.checkout.total.visible?).to eq(true)
# expect(page.checkout.total.text).to match('67.99')
# expect(page.checkout.checkout_button.visible?).to eq(true)
# expect(page.checkout.checkout_button.text).to match('Checkout')
```


#### Sections check

```ruby
expect(page).to be_like(
  cart_items: [
    {
      name: 'Cup',
      image: 'cup.png'
    },
    {
      name: 'Cap',
      image: 'cap.png'
    }
  ])

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.cart_items.size).to eq([{:name=>"Cup", :image=>"cup.png"}, {:name=>"Cap", :image=>"cap.png"}].size)
# expect(page.cart_items[0].visible?).to eq(true)
# expect(page.cart_items[0].name.visible?).to eq(true)
# expect(page.cart_items[0].name.text).to match('Cup')
# expect(page.cart_items[0].image.visible?).to eq(true)
# expect(page.cart_items[0].image['src']).to match('cup.png')
# expect(page.cart_items[1].visible?).to eq(true)
# expect(page.cart_items[1].name.visible?).to eq(true)
# expect(page.cart_items[1].name.text).to match('Cap')
# expect(page.cart_items[1].image.visible?).to eq(true)
# expect(page.cart_items[1].image['src']).to match('cap.png')
```
```ruby
expect(page).to be_like(cart_items: 2)

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.cart_items.size).to eq(2)
```
```ruby
expect(page).to be_like(cart_items: [{name: 'Cup'}, {}])

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.cart_items.size).to eq([{:name=>"Cup"}, {}].size)
# expect(page.cart_items[0].visible?).to eq(true)
# expect(page.cart_items[0].name.visible?).to eq(true)
# expect(page.cart_items[0].name.text).to match('Cup')
# expect(page.cart_items[1].visible?).to eq(true)
```

Warning! It is not possible to pass directly array:
```ruby
expect(page.cart_items).to be_like([{name: 'Cup'}, {name: 'Cap'}]) # Error
expect(page).to be_like(cart_items: [{name: 'Cup'}, {name: 'Cap'}]) # Ok
```


#### Elements check

```ruby
expect(page).to be_like(
  items: [
    'Item 1', 
    'Item 2'
])

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.items.size).to eq(["Item 1", "Item 2"].size)
# expect(page.items[0].visible?).to eq(true)
# expect(page.items[0].text).to match('Item 1')
# expect(page.items[1].visible?).to eq(true)
# expect(page.items[1].text).to match('Item 2')
```
```ruby
expect(page).to be_like(items: 2)

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.items.size).to eq(2)
```
### HTML elements
Page Object Model:
```ruby
class HtmlElements < SitePrism::Page
  set_url '/html_elements.html'

  element :input, 'input.input'
  element :textarea, 'textarea.textarea'
  element :button, 'button'
  element :button_input, 'input.button'
  element :image, 'img.image'
  elements :radios, 'input.radio'
  elements :checkboxes, 'input.checkbox'
  elements :selects, 'select.select'
end
```

#### Input

```ruby
expect(page).to be_like(input: 'Some text')

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.input.visible?).to eq(true)
# expect(page.input.value).to match('Some text')
```
```ruby
expect(page.input).to be_like(
  value: 'Some text', 
  class: 'input',        
  readonly: false,
  disabled: false
)

# Same as
# expect(page.input.visible?).to eq(true)
# expect(page.input.value).to match('Some text')
# expect(page.input[:class]).to match('input')
# expect(page.input.readonly?).to eq(false)
# expect(page.input.disabled?).to eq(false)
```

#### Button

```ruby
expect(page).to be_like(button: 'Button')

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.button.visible?).to eq(true)
# expect(page.button.text).to match('Button')
```
```ruby
expect(page.button).to be_like(
  text: 'Button', 
  disabled: false
)

# Same as
# expect(page.button.visible?).to eq(true)
# expect(page.button.text).to match('Button')
# expect(page.button.disabled?).to eq(false)
```

#### Textarea

```ruby
expect(page).to be_like(textarea: 'Some text')

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.textarea.visible?).to eq(true)
# expect(page.textarea.value).to match('Some text')
```
```ruby
expect(page.textarea).to be_like(
  value: /Some text/, 
  class: 'textarea'
)

# Same as
# expect(page.textarea.visible?).to eq(true)
# expect(page.textarea.value).to match(/Some text/)
# expect(page.textarea[:class]).to match('textarea')
```

#### Image

```ruby
expect(page).to be_like(image: /logo.png$/)

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.image.visible?).to eq(true)
# expect(page.image['src']).to match(/logo.png$/)
```
```ruby
expect(page.image).to be_like(
  src: 'logo.png', 
  class: 'logo',
  alt: 'Logo'
)

# Same as
# expect(page.image.visible?).to eq(true)
# expect(page.image.src).to match('logo.png')
# expect(page.image[:class]).to match('logo')
# expect(page.image[:alt]).to match('Logo')
```

#### Radio

```ruby
expect(page).to be_like(radios: [
  {
    checked: false,
    name: 'radio1'
  },
  {
    checked: true,
  },
  {
    checked: false,
  },
])

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.radios.size).to eq([{:checked=>false, :name=>"radio1"}, {:checked=>true}, {:checked=>false}].size)
# expect(page.radios[0].visible?).to eq(true)
# expect(page.radios[0].checked?).to eq(false)
# expect(page.radios[0].name).to match('radio1')
# expect(page.radios[1].visible?).to eq(true)
# expect(page.radios[1].checked?).to eq(true)
# expect(page.radios[2].visible?).to eq(true)
# expect(page.radios[2].checked?).to eq(false)
```
```ruby
expect(page).to be_like(radios: [
  false, 
  true, 
  false
])

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.radios.size).to eq([false, true, false].size)
# expect(page.radios[0].visible?).to eq(true)
# expect(page.radios[0].checked?).to eq(false)
# expect(page.radios[1].visible?).to eq(true)
# expect(page.radios[1].checked?).to eq(true)
# expect(page.radios[2].visible?).to eq(true)
# expect(page.radios[2].checked?).to eq(false)
```

#### Check box

```ruby
expect(page).to be_like(checkboxes: [
  {
    checked: false,
    id: "checkbox-not-checked"
  },
  {
    checked: true,
  }
])

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.checkboxes.size).to eq([{:checked=>false, :id=>"checkbox-not-checked"}, {:checked=>true}].size)
# expect(page.checkboxes[0].visible?).to eq(true)
# expect(page.checkboxes[0].checked?).to eq(false)
# expect(page.checkboxes[0].id).to match('checkbox-not-checked')
# expect(page.checkboxes[1].visible?).to eq(true)
# expect(page.checkboxes[1].checked?).to eq(true)
```
```ruby
expect(page).to be_like(checkboxes: [
  false, 
  true
])

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.checkboxes.size).to eq([false, true].size)
# expect(page.checkboxes[0].visible?).to eq(true)
# expect(page.checkboxes[0].checked?).to eq(false)
# expect(page.checkboxes[1].visible?).to eq(true)
# expect(page.checkboxes[1].checked?).to eq(true)
```
```ruby
expect(page.checkboxes[0]).to be_like(
  checked: false,
  id: "checkbox-not-checked"
)

# Same as
# expect(page.checkboxes[0].visible?).to eq(true)
# expect(page.checkboxes[0].checked?).to eq(false)
# expect(page.checkboxes[0].id).to match('checkbox-not-checked')
```

#### Select

```ruby
expect(page).to be_like(selects: [
  { 
    value: /^$/, 
    id: 'select-not-selected' 
  },
  { 
    value: 'option2', 
    id: 'select-selected' 
  }
])

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.selects.size).to eq([{:value=>/^$/, :id=>"select-not-selected"}, {:value=>"option2", :id=>"select-selected"}].size)
# expect(page.selects[0].visible?).to eq(true)
# expect(page.selects[0].value).to match(/^$/)
# expect(page.selects[0].id).to match('select-not-selected')
# expect(page.selects[1].visible?).to eq(true)
# expect(page.selects[1].value).to match('option2')
# expect(page.selects[1].id).to match('select-selected')
```
### Visibility
Page Object Model:
```ruby
class Visibility < SitePrism::Page
  set_url '/visibility.html'

  elements :list_items, 'li'
  section  :article, 'article' do
    # ...
  end
end
```

#### Element or section

```ruby
expect(page).to be_like(article: :invisible)

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.article.invisible?).to eq(true)
```

#### Elements or sections

```ruby
expect(page).to be_like(list_items: [
  'Element 1', 
  :invisible, 
  :invisible, 
  :visible
])

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.list_items.size).to eq(["Element 1", :invisible, :invisible, :visible].size)
# expect(page.list_items[0].visible?).to eq(true)
# expect(page.list_items[0].text).to match('Element 1')
# expect(page.list_items[1].invisible?).to eq(true)
# expect(page.list_items[2].invisible?).to eq(true)
# expect(page.list_items[3].visible?).to eq(true)
```
### Absence
Page Object Model:
```ruby
class Absence < SitePrism::Page
  set_url '/absence.html'

  element  :article, 'article'
end
```

#### Element or section

```ruby
expect(page).to be_like(article: :absent)

# Same as
# expect(page.loaded?).to eq(true)
# expect(page.has_no_article?).to eq(true)
```

#### Delay before checking absence

Sometimes we need to sleep before checking absence. Use :absent[delay in seconds]
```ruby
expect(page).to be_like(article: :absent3)

# Same as
# expect(page.loaded?).to eq(true)
# sleep 3
# expect(page.has_no_article?).to eq(true)
```
## Configuration

### String comparison

#### Exact match and inclusion

By default the inclusion of a substring in a string is checked
```ruby
PrismChecker.string_comparison = :inclusion # default value
expect(page.header).to be_like('Shopping Cart')

# Same as
# expect(page.header.visible?).to eq(true)
# expect(page.header.text).to match('Shopping Cart')
```
To compare strings exactly, use :exact
```ruby
PrismChecker.string_comparison = :exact
expect(page.header).to be_like('Shopping Cart')

# Same as
# expect(page.header.visible?).to eq(true)
# expect(page.header.text).to eq('Shopping Cart')
```

#### Empty string

When the comparison method is :inclusion, and it is necessary to compare with an empty string, it can be done in this way
```ruby
expect(page.element_without_text).to be_like(:empty)

# Same as
# expect(page.element_without_text.text.empty?).to eq(true)
```
or
```ruby
expect(page.element_without_text).to be_like(/^$/)

# Same as
# expect(page.element_without_text.visible?).to eq(true)
# expect(page.element_without_text.text).to match(/^$/)
```

### Colorizer

Failure reports are colorized through `PrismChecker.colorizer`. `prism_checker_rspec` sets one that
uses the RSpec console codes; the default of the core gem returns text unchanged.

A colorizer answers `colorize(text, code)`, where `code` is one of `:success`, `:failure`,
`:detail` or `:white`:

```ruby
class MyColorizer
  CODES = { success: 32, failure: 31, detail: 33, white: 37 }.freeze

  def self.colorize(text, code)
    "\e[#{CODES[code]}m#{text}\e[0m"
  end
end

PrismChecker.colorizer = MyColorizer
```
