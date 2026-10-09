package com.devops.employee_service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

class TaskUnitTest {

    private Task task;

    @BeforeEach
    void setUp() {
        task = Task.builder()
                .id(100L)
                .title("Build CI/CD Pipeline")
                .description("Configure Jenkinsfile for Spring Boot and Podman")
                .status("PENDING")
                .dueDate(LocalDateTime.now().plusDays(3))
                .build();
    }

    @Test
    @DisplayName("Test Task Object Creation and Getters")
    void testTaskCreation() {
        assertNotNull(task);
        assertEquals(100L, task.getId());
        assertEquals("Build CI/CD Pipeline", task.getTitle());
        assertEquals("Configure Jenkinsfile for Spring Boot and Podman", task.getDescription());
        assertEquals("PENDING", task.getStatus());
        assertNotNull(task.getDueDate());
    }

    @Test
    @DisplayName("Test Task Status Update")
    void testTaskStatusUpdate() {
        task.setStatus("COMPLETED");
        assertEquals("COMPLETED", task.getStatus());
    }

    @Test
    @DisplayName("Test Task Default Status On PrePersist")
    void testTaskPrePersist() {
        Task newTask = new Task();
        newTask.setTitle("Deploy Container");
        newTask.onCreate();

        assertNotNull(newTask.getCreatedAt());
        assertEquals("PENDING", newTask.getStatus());
    }
}
