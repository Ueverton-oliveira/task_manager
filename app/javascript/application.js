document.querySelectorAll('a[data-method="delete"]').forEach(el => {
  el.addEventListener('click', function(event) {
    if (!confirm('Você tem certeza?')) {
      event.preventDefault();
    }
  });
});