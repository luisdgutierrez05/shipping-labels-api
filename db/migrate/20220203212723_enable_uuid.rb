# frozen_string_literal: true

# Migration to enable UUID usage in PostgreSQL
class EnableUuid < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'
  end
end
