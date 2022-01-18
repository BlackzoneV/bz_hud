window.addEventListener("message", function (event) {
  switch (event.data.action) {
    case "hud":
      Progress(event.data.health, ".health");
      Progress(event.data.armor, ".armor");
  }
});

function Progress(percent, element) {
  var circle = document.querySelector(element);
  var circumference = "111" * 2 * Math.PI;
  var html = $(element).parent().parent().find("span");

  

  if (element == ".health") {
      circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;
	  
	  const offset = circumference - ((-percent * 25) / 100 / 100) * circumference;
  circle.style.strokeDashoffset = -offset;
  }else if(element == ".armor"){
      circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;
	  
	  const offset = circumference - ((-percent * 50) / 100 / 100) * circumference;
    circle.style.strokeDashoffset = offset;
	}

  html.text(Math.round(percent));
}
