function copyToClipboard (value) {
  var temporaryInputElement = document.createElement('input');
  temporaryInputElement.type = 'text';
  temporaryInputElement.value = value;
  document.body.appendChild(temporaryInputElement);
  temporaryInputElement.select();
  document.execCommand('Copy');
  document.body.removeChild(temporaryInputElement);
}

function copy (value) {
  return copyToClipboard(value);
}
