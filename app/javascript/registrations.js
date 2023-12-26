function previewImage() {
  const image_element = document.querySelector("#user_image")
  const fileReader = new FileReader();
  fileReader.onload = () => {
    document.querySelector('.js-preview').src = fileReader.result;
  };
  fileReader.readAsDataURL(image_element.files[0]);
}

window.previewImage = previewImage
