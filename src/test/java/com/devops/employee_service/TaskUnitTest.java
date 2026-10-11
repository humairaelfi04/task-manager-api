package com.devops.employee_service;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class TaskUnitTest {

    @Test
    void testTaskCreation() {
        Task task = new Task();
        task.setTitle("Test Task");
        task.setDescription("Unit test for task creation");

        assertEquals("Test Task", task.getTitle());
        assertEquals("Unit test for task creation", task.getDescription());
    }

    @Test
    void testDefaultStatusOnPrePersist() {
        Task task = new Task();
        task.setTitle("Status Test");
        task.onCreate();

        assertEquals("PENDING", task.getStatus());
    }

    @Test
    void testDefaultPriorityOnPrePersist() {
        Task task = new Task();
        task.setTitle("Priority Test");
        task.onCreate();

        assertEquals("LOW", task.getPriority());
    }

    @Test
    void testCustomPriorityIsPreserved() {
        Task task = new Task();
        task.setTitle("High Priority Task");
        task.setPriority("HIGH");
        task.onCreate();

        assertEquals("HIGH", task.getPriority());
    }

    @Test
    void testCustomStatusIsPreserved() {
        Task task = new Task();
        task.setTitle("In Progress Task");
        task.setStatus("IN_PROGRESS");
        task.onCreate();

        assertEquals("IN_PROGRESS", task.getStatus());
    }
}
