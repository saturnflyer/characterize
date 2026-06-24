# frozen_string_literal: true

require "test_helper"

describe Characterize::Collection do
  it "wraps plain enumerables" do
    collection = Characterize::Collection.for([1, 2, 3])

    assert_instance_of Characterize::Collection, collection
    refute_instance_of Characterize::RelationCollection, collection
    assert_equal [1, 2, 3], collection.collection
  end

  it "uses a compact inspect" do
    collection = Characterize::Collection.for([1])

    assert_equal "#<Characterize::Collection #{collection.object_id}>", collection.inspect
  end
end

describe Characterize::RelationCollection do
  def characterized(relation)
    Characterize::Collection.for(relation, UserCollectionCharacter)
  end

  it "wraps ActiveRecord relations" do
    collection = Characterize::Collection.for(User.unscoped)

    assert_instance_of Characterize::RelationCollection, collection
  end

  it "loads ActiveRecord query delegators without invalid Direction methods" do
    assert Characterize::RelationCollection.instance_methods.include?(:where)
    refute Characterize::RelationCollection.instance_methods.include?(:"preload!")
  end

  it "rebuilds characterized items after not" do
    User.create!(name: "Zoe")

    names = characterized(User.unscoped.order(:id)).not(name: "Zoe").map(&:index_name)

    assert_equal ["Amy in a collection"], names
  ensure
    User.where(name: "Zoe").delete_all
  end

  it "returns self from not for chaining" do
    collection = Characterize::Collection.for(User.unscoped, UserCollectionCharacter)

    assert_same collection, collection.not(name: "missing")
  end

  it "rebuilds characterized items after limit" do
    User.create!(name: "Zoe")

    names = characterized(User.unscoped.order(:id)).limit(1).map(&:index_name)

    assert_equal ["Amy in a collection"], names
  ensure
    User.where(name: "Zoe").delete_all
  end

  it "returns self from limit for chaining" do
    collection = Characterize::Collection.for(User.unscoped, UserCollectionCharacter)

    assert_same collection, collection.limit(1)
  end

  it "rebuilds characterized items after offset" do
    User.create!(name: "Zoe")

    names = characterized(User.unscoped.order(:id)).offset(1).map(&:index_name)

    assert_equal ["Zoe in a collection"], names
  ensure
    User.where(name: "Zoe").delete_all
  end

  it "returns self from offset for chaining" do
    collection = Characterize::Collection.for(User.unscoped, UserCollectionCharacter)

    assert_same collection, collection.offset(1)
  end
end
