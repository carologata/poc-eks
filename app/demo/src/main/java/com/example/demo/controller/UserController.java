package com.example.demo.controller;

import com.example.demo.model.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/api")
@Slf4j
public class UserController {

    @GetMapping("/")
    public String hello() {
        log.info("Handling request to the root path");
        return "Hello, World!";
    }

    @GetMapping("/users")
    public ResponseEntity<List<User>> getUsers() {
        log.info("Fetching all users");
        
        List<User> users = Arrays.asList(
            new User("Alice", "alice@example.com"),
            new User("Bob", "bob@example.com")
        );
        
        log.debug("Returning {} users", users.size());
        return ResponseEntity.ok(users);
    }

    @PostMapping("/users")
    public ResponseEntity<User> createUser(@RequestBody User user) {
        log.info("Creating new user: {}", user.getName());
        log.debug("User details: {}", user);
        
        // In a real application,   save this to a database
        
        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }

    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        log.info("Health check endpoint called");
        return ResponseEntity.ok("Service is up and running!");
    }
}
