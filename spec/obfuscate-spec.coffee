{WorkspaceView} = require 'atom'
Obfuscate = require '../lib/obfuscate'

describe "obfuscating text", ->
  [activationPromise, editor, editorView] = []

  obfuscate = (callback) ->
    editorView.trigger "obfuscate:text"
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync()

    editorView = atom.workspaceView.getActiveView()
    editor = editorView.getEditor()

    activationPromise = atom.packages.activatePackage('obfuscate')


  describe "when no lines are selected", ->
    it "obfuscates the current line", ->
      editor.setText """
        One 1
        Two 2
      """
      editor.setCursorBufferPosition([0, 0])

      obfuscate ->
        [line_1, line_2] = editor.getText().split("\n")

        expect(line_1).not.toBe("One 2")
        expect(line_1).toMatch(/[A-Z][a-z][a-z] \d/)
        expect(line_2).toBe("Two 2")

  describe "when text is selected text", ->
    it "obfuscates only the selection", ->
      editor.setText """
        Once upon a time there was a text range
        it was quite nice until it got all obfuscated.
      """
      # Select just after "Once" until the next line just before "obfuscated".
      editor.setSelectedBufferRange([[0, 4], [1,35]])

      obfuscate ->
        [line_1, line_2] = editor.getText().split("\n")
        expect(line_1).not.toBe("Once upon a time there was a text range")
        expect(line_2).not.toBe("it was quite nice until it got all obfuscated.")
        expect(line_1).toMatch(/^Once/)
        expect(line_2).toMatch(/obfuscated\.$/)
