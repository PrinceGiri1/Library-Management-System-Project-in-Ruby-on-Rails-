function check_file(){
    str=document.getElementById('image').value.toUpperCase();
    suffix=".PNG";
    suffix2=".JPEG";
    if(str.indexOf(suffix, str.length - suffix.length) == -1||
        str.indexOf(suffix2, str.length - suffix2.length) == -1){
        alert('File type not allowed,\nAllowed file: *.png,*.jpeg');
        document.getElementById('image').value='';
    }
}