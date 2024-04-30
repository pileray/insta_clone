import mdb from "mdb-ui-kit"

const mdbInputUpdate = () => {
  document.querySelectorAll('.form-outline').forEach((formOutline) => {
    new mdb.Input(formOutline).init();
  });
}

document.addEventListener('turbo:render', () => {
  mdbInputUpdate();
});

document.addEventListener('turbo:frame-render', () => {
  mdbInputUpdate();
});

document.addEventListener('turbo:submit-end', () => {
  setTimeout(
    mdbInputUpdate,
    100
  )
});