module.exports =
  obfuscateView: null

  activate: (state) ->
    atom.workspaceView.command "obfuscate:text", => @obfuscateText()
    atom.workspaceView.command "obfuscate:letters", => @obfuscateLetters()
    atom.workspaceView.command "obfuscate:numbers", => @obfuscateNumbers()

  # Obfuscates ascii letters and numbers
  obfuscateText: ->
    replaceText (text) ->
      text = replaceFromRange text, "A","Z"
      text = replaceFromRange text, "a","z"
      text = replaceFromRange text, "0","9"

  # Obfuscates ascii letters
  obfuscateLetters: ->
    replaceText (text) ->
      text = replaceFromRange text, "A","Z"
      text = replaceFromRange text, "a","z"

  # Obfuscates numbers
  obfuscateNumbers: ->
    replaceText (text) ->
      text = replaceFromRange text, "0","9"

# Replace either selected text, or current line with the results of callback.
replaceText = (callback) ->
  editor = atom.workspaceView.getActivePaneItem()
  selection = editor.getSelection()
  if selection.isEmpty()
    selection = editor.selectLine()[0]

  text = selection.getText()

  obfuscated = callback(text)
  selection.insertText(obfuscated)

# Scrambles text within a unicode range.
#
#     replaceFromRange "Hello There", "a", "z"
#     #=> "Haxoz Toopu"
#
replaceFromRange = (text, startChar, endChar) ->
  sample = stringFromCharRange(startChar, endChar)
  replaceFromSample(text, sample)

# Scrambles characters within a given sample.
#
#     replaceFromSample "Hello There", "elo"
#     #=> "Hoolo Thlro"
#
replaceFromSample = (text, sample) ->
  # The regexp will break on a sample with brackets, then again we never use it
  # that way...
  regexp = new RegExp("["+sample+"]","g")
  length = sample.length

  text.replace regexp, (char) ->
    sample[parseInt Math.random() * length, 10]

# Generates a string from unicode range.
#
#   stringFromCharRange("A", "D")
#   #=> "ABCD"
#
stringFromCharRange = (startChar, endChar) ->
  start = startChar.charCodeAt(0)
  end   = endChar.charCodeAt(0)

  chars = (String.fromCharCode c for c in [start .. end])
  chars.join ""
