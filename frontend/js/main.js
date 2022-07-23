async function getUsers(){
    fetch('/api/db/users')
    .then(response=>response.json())
    .then(users => {
        let users_list = document.getElementById('users_list');
        users_list.innerHTML = ''

        let ul = document.createElement('ul');
        users.forEach(item => {
            let li = document.createElement('li');
            ul.appendChild(li);
            li.innerHTML += item.name;
        });

        users_list.append(ul)

    })
    
    .catch(error =>console.log(error));
}

async function createUser(){
    let user_name = document.getElementById('name').value;
    data = {
        name : user_name
    };

    if(user_name != ''){
        fetch('/api/db/user',{
            method: 'POST',
            body: JSON.stringify(data),
            headers:{
                'Content-Type': 'application/json'
            }
        })
        .then(response=>console.log(response))
        .catch(error => console.log(error))
    } 

}

async function getGames(){
    fetch('/api/balde/games')
    .then(response=>response.json())
    .then(games => {
        console.log(games)
        let games_list = document.getElementById('games_list');
        games_list.innerHTML = ''

        let ul = document.createElement('ul');
        games.forEach(item => {
            let li = document.createElement('li');
            let game = document.createElement('span');
            li.append(game)
            game.innerHTML += item;
            game.style="text-decoration:underline";
            game.classList.add("game_link");

            game.addEventListener('click',function(){
                downloadGame(item);
            });
            ul.appendChild(li);
        });
        games_list.append(ul)
    })
    .catch(error =>console.log(error));
}

async function downloadGame(game){

    fetch('/api/balde/games/'+game)
    .then( res => res.blob() )
    .then( blob => {
        var file = window.URL.createObjectURL(blob);
        window.location.assign(file);
    })
    .catch(error => console.log(error));


}
