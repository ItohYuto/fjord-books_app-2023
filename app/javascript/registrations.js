document.getElementById('user_image').onchange = function() {
  var fileReader = new FileReader();
  fileReader.onload = (function() {
    document.getElementById('preview').src = fileReader.result;
  });
  fileReader.readAsDataURL(this.files[0]);
}
