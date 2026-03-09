require "pagy"

# Pagy initializer file
# frozen_string_literal: true

# The Pagy::DEFAULT hash is frozen in newer versions of Pagy.
# You can no longer set default values globally like this:
# Pagy::DEFAULT[:items] = 20
# Pagy::DEFAULT[:size]  = [1, 4, 4, 1]

# Instead, you should pass the options directly to the `pagy` method in your controllers:
# @pagy, @records = pagy(Product.all, items: 20)

# If you need to include any extras, you can still do it here.
# For example:
require "pagy/extras/array"
