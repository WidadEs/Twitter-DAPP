// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SocialNetwork {
    struct Post {
        uint id;
        address author;
        string content;
        uint likes;
        uint dislikes;
        uint createdAt;
        uint updatedAt;
    }

    mapping(uint => Post) public posts;
    mapping(address => uint) public userPostCount;
    uint public postCount;

    event PostCreated(uint id, address author, uint createdAt);
    event PostUpdated(uint id, string content, uint updatedAt);
    event Liked(uint id, uint likes);
    event Disliked(uint id, uint dislikes);

    // Se connecter (aucune action nécessaire en Solidity car les transactions se font avec des wallets)
    
    // Ajouter un post
    function addPost(string memory _content) public {
        postCount++;
        posts[postCount] = Post(
            postCount,
            msg.sender,
            _content,
            0,
            0,
            block.timestamp,
            block.timestamp
        );
        userPostCount[msg.sender]++;
        emit PostCreated(postCount, msg.sender, block.timestamp);
    }

    // Voir un post par ID
    function getPost(uint _id) public view returns (Post memory) {
        require(_id > 0 && _id <= postCount, "Post does not exist.");
        return posts[_id];
    }

    // Modifier le post (seulement le propriétaire)
    function updatePost(uint _id, string memory _newContent) public {
        Post storage post = posts[_id];
        require(msg.sender == post.author, "You are not the owner of this post.");
        post.content = _newContent;
        post.updatedAt = block.timestamp;
        emit PostUpdated(_id, _newContent, block.timestamp);
    }

    // Faire un Like
    function likePost(uint _id) public {
        require(_id > 0 && _id <= postCount, "Post does not exist.");
        posts[_id].likes++;
        emit Liked(_id, posts[_id].likes);
    }

    // Faire un Dislike
    function dislikePost(uint _id) public {
        require(_id > 0 && _id <= postCount, "Post does not exist.");
        posts[_id].dislikes++;
        emit Disliked(_id, posts[_id].dislikes);
    }

    // Obtenir le nombre de likes et de dislikes pour un post
    function getLikesAndDislikes(uint _id) public view returns (uint likes, uint dislikes) {
        require(_id > 0 && _id <= postCount, "Post does not exist.");
        return (posts[_id].likes, posts[_id].dislikes);
    }

    // Obtenir la date de création et de modification d'un post
    function getTimestamps(uint _id) public view returns (uint createdAt, uint updatedAt) {
        require(_id > 0 && _id <= postCount, "Post does not exist.");
        return (posts[_id].createdAt, posts[_id].updatedAt);
    }
}
