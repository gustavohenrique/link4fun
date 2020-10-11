window.dataLayer = window.dataLayer || [];
function gtag () {
  dataLayer.push(arguments);
}
gtag('js', new Date());
gtag('config', 'UA-6431766-3');

function toggleMenu (component) {
  const cls = 'is-active';
  const hide = 'lf-hide';
  const menu = document.querySelector('#menu-mobile');
  if (component.classList.contains(cls)) {
    component.classList.remove(cls);
    menu.classList.remove(cls);
    menu.classList.add(hide);
  } else {
    component.classList.add(cls);
    menu.classList.add(cls);
    menu.classList.remove(hide);
  }
}

function copyToClipboard (value) {
  const temporaryInputElement = document.createElement('input');
  temporaryInputElement.type = 'text';
  temporaryInputElement.value = value;
  document.body.appendChild(temporaryInputElement);
  temporaryInputElement.select();
  document.execCommand('Copy');
  document.body.removeChild(temporaryInputElement);
  gtag('event', 'share', {
    content_type: 'link',
    item_id: value,
    method: 'Copy Link'
  });

}

function copy (component, value) {
  component.disabled = true;
  component.innerText = 'Copied';
  return copyToClipboard(value);
}
