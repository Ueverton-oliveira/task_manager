//= link_tree ../images
//= link_directory ../stylesheets .css
//= link tailwind.css
//= link application.js


$('#exampleModal').on('show.bs.modal', function (event) {
  var button = $(event.relatedTarget) // Button that triggered the modal
  var recipient = button.data('whatever') // Extract info from data-* attributes
  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
  var modal = $(this)
  modal.find('.modal-title').text('New message to ' + recipient)
  modal.find('.modal-body input').val(recipient)
})//= link_tree ../builds

document.querySelectorAll('a[data-method="delete"]').forEach(el => {
  el.addEventListener('click', function(event) {
    if (!confirm('Você tem certeza?')) {
      event.preventDefault();
    }
  });
});
