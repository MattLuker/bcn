# Dynamic Table Rows with CoffeeScript

## Gimme More Rows

I might have written about it before, I know I’ve made a [video](https://youtu.be/q0-HLKpyvHs) about it, but sometime you need to add rows to an HTML table.  I originally hacked up some code to do this using pure jQuery.  Trust me the code was terrible, fragile, and I think it actually smelled bad (kind of like moldy dish towel and day old poop diaper).  I guess it’s true what they say “You’re not doing good work if you’re not embarrassed by your first draft”, Or something like that.

The whole dynamic row thing is great if you are converting paper forms to HTML.  At least this is the situation I seem to find myself in frequently and need to add some additional rows to a table.  In these cases the cells of the row always container some type of form element.

## Enter CoffeeScript

This time around instead of [jQuery](https://jquery.com/) or [Angular.js](https://angularjs.org/) I’m tackling the problem with [CoffeeScript](http://coffeescript.org/).  Well CoffeeScript with a massive does of jQuery cause you just can’t do too much without jQuery… (again it feels like that may just be me).

In a Rails app CoffeeScript is a snap.  Check out this **add_row** function I’ve whipped up inside the *app/assetss/javascripts/forms.coffee* file:

```

 add_row = (table_body_element) -> # Get some variables for the tbody and the row to clone.   $tbody = $('#' + table_body_element)   $rows = $($tbody.children('tr'))   $cloner = $rows.eq(0)   count = $rows.length    # Clone the row and get an array of the inputs.   $new_row = $cloner.clone()   inputs = $new_row.find('.dyn-input')    # Change the name and id for each input.   $.each(inputs, (i, v) ->     $input = $(v)      # Find the label for input and adjust it.     $label = $new_row.find("label[for='#{$input.attr('id')}']")     $label.attr( {'for': $input.attr('id').replace(/\[.*\]/, "[#{count + 1}]")} )      $input.attr({       'name': $input.attr('name').replace(/\[.*\]/, "[#{count + 1}]"),       'id': $input.attr('id').replace(/\[.*\]/, "[#{count + 1}]")     })      # Remove values and checks.     $input.val('')     checked = $input.prop('checked')     if checked       $input.prop('checked', false)   )    # Add the new row to the tbody.   $tbody.append($new_row)

```

* So the function takes a **tbody** element then grabs the **tr** elements (which should be the first row).

* Then some variables are setup with the jQuery selector for the first row and a **count** variable which will be used to uniquely identify the added rows.

* The jQuery **clone** method is used to create a new row and all **input** elements are found that have the class of **.dyn-input**.

* The new row’s inputs are then looped over with the jQuery **$.each** method.

* Any labels for the field are found and the **for** attribute is changed to include the incremented **count** variable from earlier.

* Next, it’s the input elements turn to be changed.  Both the **id** and **name** attributes are appended with a count.

* Finally, the **value** and **checked** properties are removed/blanked and the new row is appended to the **tbody** element passed in as an argument.

## Cute as a  Buttons 

To add the row and fire the **add_row** function there is a button and on that button’s **click** event there is a **handler** and in that **handler’s** callback function the **add_row** function is called:

```

$('#add-row').on 'click', (e) ->   e.preventDefault()   table_body = $(e.target).data().table   if table_body     add_row(table_body)

```

Well **add_row** is called after finding the **tbody** element.

## Conclusion

I think this is the cleanest implementation of the table with dynamic rows feature.  Maybe one day I’ll find someone to pass my form processing web app off to, and I won’t have to deal with tables and rows and adding.  Maybe one day…

In the meantime I’ve been learning more and more about JavaScript, mostly from [Treehouse](http://referrals.trhou.se/adamsommer) courses, and I’ve been thinking about coding up a jQuery plugin to handle the whole dynamic rows business.

We’ll see how it goes and what time allows.

Party On!