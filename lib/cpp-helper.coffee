{CompositeDisposable} = require 'atom'

module.exports =
  emptyLine: /^\s*$/

  activate: (state) ->
    # Register command that toggles this view
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor',
      'cpp-helper:bracket': => @bracket()

  deactivate: ->
    @subscriptions.dispose()

  bracket: ->
    console.log 'Bracket was pressed!'
    editor = atom.workspace.getActivePaneItem()

    if 'source.cpp' in editor.getRootScopeDescriptor().scopes

      cursor = editor.getCursorBufferPosition()
      line = editor.getTextInRange([[cursor.row, 0], cursor])

      # we only insert a newline if some content precedes the cursor on this line
      if @emptyLine.test line
        list = '{\n'
      else
        list = '\n{\n'

      # insert all chars and auto indent
      for char in list
        editor.insertText char, {
          autoIndent: true
          autoIndentNewline:true
          autoDecreaseIndent: true
        }

      # select autoinserted closing bracket
      editor.selectToEndOfLine()
      selection = editor.getLastSelection()
      selection.indentSelectedRows()

    else
      editor.insertText '{'
