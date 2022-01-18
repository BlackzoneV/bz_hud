$(document).ready(function(){
   // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Trigger adding a new message to the log and create its display
    if (item.open === 2) {
     // console.log(3)
     // update(item.info);

      if (item.direction) {
        $(".direction").find(".image").attr('style', 'transform: translate3d(' + item.direction + 'px, 0px, 0px)');
        return;
      }

      if (item.atl === false) {
        $(".atlamount").attr("style", "display: none");
        $(".atlamounttxt").attr("style", "display: none");
      }
      else {
        $(".atlamount").attr("style", "display: block");
        $(".atlamounttxt").attr("style", "display: block");
        $(".atlamount").empty();
        $(".atlamount").append(item.atl);
      }
      
      $(".vehicle").removeClass("hide");
      $(".wrap").removeClass("lower");
      $(".time").removeClass("timelower");

      $(".fuelamount").empty();
      $(".fuelamount").append(item.fuel);
	  setProgressFuel(item.fuel,'.progress-fuel');

      $(".speedamount").empty();
      $(".speedamount").append(item.mph);
	  setProgressSpeed(item.mph,'.progress-speed');
	  
	  // if (item.mph >= 200) {
		  // setProgressSpeed(item.mph,'.progress-speedx');
	  // } else {
		  // setProgressSpeed(item.mph,'.progress-speed');
	  // }

      $(".street-txt").empty();
      $(".street-txt").append(item.street);
      
      $(".time").empty();
      $(".time").append(item.time); 

      if (item.belt == true || item.harnessDur > 0) {	
        $(".belt").fadeOut(1000);	
      } else {	
        $(".belt").fadeIn(500).fadeOut(500);
      }

      if (item.engine === true) {
        $(".ENGINE").fadeIn(1000);
      } else {
        $(".ENGINE").fadeOut(1000);
      }
    }

    if (item.open === 4) {
      $(".vehicle").addClass("hide");
      $(".wrap").addClass("lower");
      $(".time").addClass("timelower");
      $(".fuelamount").empty();
      $(".speedamount").empty();
      $(".street-txt").empty();
      $(".belt-txt").empty();

      $(".time").empty();
      $(".time").append(item.time); 
      $(".direction").find(".image").attr('style', 'transform: translate3d(' + item.direction + 'px, 0px, 0px)');
    }

    if (item.open === 3) {
      $(".full-screen").fadeOut(100);    
    }    
    if (item.open === 1) {
      //console.log(1)
      $(".full-screen").fadeIn(1000);    
    }    
  });
});

function setProgressSpeed(value, element){	
  var circle = document.querySelector(element);	
  var radius = circle.r.baseVal.value;	
  var circumference = radius * 2 * Math.PI;	
  var html = $(element).parent().parent().find('span');	
  var percent = value*100/220;	
  circle.style.strokeDasharray = `${circumference} ${circumference}`;	
  circle.style.strokeDashoffset = `${circumference}`;	
  const offset = circumference - ((-percent*53)/100) / 100 * circumference;	
  circle.style.strokeDashoffset = -offset;	
  var predkosc = Math.floor(value * 1.8)	
  if (predkosc == 81 || predkosc == 131) {	
    predkosc = predkosc - 1	
  }	
  html.text(predkosc);	
}	
function setProgressFuel(percent, element){	
  var circle = document.querySelector(element);	
  var radius = circle.r.baseVal.value;	
  var circumference = radius * 2 * Math.PI;	
  var html = $(element).parent().parent().find('span');	
  circle.style.strokeDasharray = `${circumference} ${circumference}`;	
  circle.style.strokeDashoffset = `${circumference}`;	
  const offset = circumference - ((-percent*73)/100) / 100 * circumference;	
  circle.style.strokeDashoffset = -offset;	
  html.text(Math.round(percent));	
}