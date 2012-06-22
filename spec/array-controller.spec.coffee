Backbone = require "backbone"
ArrayController = require "../array-controller.js"

describe "ArrayController", ->
  beforeEach ->

  it "should have a length", ->
    collection = new ArrayController()
    expect(collection.length).toBe(0)

  describe "Adding objects", ->
    collection = null
    beforeEach ->
      collection = new ArrayController()

    it "should be able to hold a string", ->
      collection.add("In Cold Blod")
      expect(collection.at(0)).toBe("In Cold Blod")
      
    it "should be able to add an array of objects", ->
      collection.add(["On the Road", "The Great Gatsby"])
      expect(collection.at(0)).toBe("On the Road")

    it "should be able to add an object in the constructor", ->
      collection = new ArrayController("On the Road")
      expect(collection.at(0)).toBe("On the Road")

    it "should be able to add an array of objects in the constructor", ->
      collection = new ArrayController(["On the Road", "The Great Gatsby"])
      expect(collection.at(0)).toBe("On the Road")


  describe "Removing objects", ->
    collection = null
    beforeEach ->
      collection = new ArrayController(['Doppler', 'In Cold Blod', 'On the Road', 'The Great Gatsby'])

    it "should be able to remove an object", ->
      expect(collection.length).toBe(4)
      collection.remove("Doppler")
      expect(collection.length).toBe(3)

    it "should be able to remove an array of strings", ->
      expect(collection.length).toBe(4)

      collection.remove(["Doppler"])
      expect(collection.length).toBe(3)

    it "should not change the length if removing a not exisiting object", ->
      expect(collection.length).toBe(4)
      collection.remove(["Huckleberry Finn"])
      expect(collection.length).toBe(4)

    it "should be able to remove a set of objects", ->
      expect(collection.length).toBe(4)
      collection.remove(["Doppler", "The Great Gatsby"])
      expect(collection.length).toBe(2)

  describe "Reset", ->
    collection = null
    beforeEach ->
      collection = new ArrayController(['Doppler', 'In Cold Blod', 'On the Road', 'The Great Gatsby'])

    it "should be able to reset with no argumets", ->
      expect(collection.length).toBe(4)
      collection.reset()
      expect(collection.length).toBe(0)

    it "should be able to reset to an object", ->
      expect(collection.length).toBe(4)
      collection.reset("Doppler")
      expect(collection.length).toBe(1)

    it "should be able to reset with an array of objects", ->
      expect(collection.length).toBe(4)
      collection.reset(["Huckleberry Finn"])
      expect(collection.length).toBe(1)

  describe "Sort", ->
    collection = null
    beforeEach ->
      collection = new ArrayController(['Doppler', 'In Cold Blod', 'On the Road', 'The Great Gatsby'])

    it "should sort", ->
      console.log('Collection: ', collection)


  describe "Events", ->
    collection = null
    events = null
    beforeEach ->
      collection = new ArrayController(['Doppler', 'In Cold Blod', 'On the Road', 'The Great Gatsby'])
      events = {
        add: ->
        remove: ->
        reset: ->
        all: ->
      }
      spyOn(events, 'add')
      spyOn(events, 'remove')
      spyOn(events, 'reset')
      spyOn(events, 'all')

      collection.on 'add', events.add
      collection.on 'remove', events.remove
      collection.on 'reset', events.reset
      collection.on 'all', events.all

    it "should send reset event", ->
      collection.reset("Huckleberry Finn")

      expect(events.add).not.toHaveBeenCalled()
      expect(events.remove).not.toHaveBeenCalled()
      expect(events.reset).toHaveBeenCalled()
      expect(events.reset).toHaveBeenCalled()

    it "should send add event", ->
      collection.add("Huckleberry Finn")      
      expect(events.add).toHaveBeenCalled()
      expect(events.all).toHaveBeenCalledWith('add', "Huckleberry Finn", collection, {})

    it "should not send add event when silent", ->
      collection.add("Huckleberry Finn", {silent: true})      
      expect(events.add).not.toHaveBeenCalled()
      expect(events.all).not.toHaveBeenCalled()

    it "should send remove event", ->
      collection.remove("In Cold Blod")      
      expect(events.remove).toHaveBeenCalled()
      expect(events.all).toHaveBeenCalledWith('remove', "In Cold Blod", collection, {})

    it "should not send remove event when silent", ->
      collection.remove("In Cold Blod", {silent: true})      
      expect(events.remove).not.toHaveBeenCalled()
      expect(events.all).not.toHaveBeenCalled()

return