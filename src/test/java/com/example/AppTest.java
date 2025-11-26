package com.example;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Field;
import java.util.ArrayList;

public class AppTest {

    private ArrayList<String> tasks;

    @BeforeEach
    public void setup() throws Exception {
        // Access the private static "tasks" field using reflection
        Field field = App.class.getDeclaredField("tasks");
        field.setAccessible(true);

        tasks = (ArrayList<String>) field.get(null);
        tasks.clear(); // reset before each test
    }

    @Test
    public void testAddTask() throws Exception {
        tasks.add("Buy groceries");
        assertEquals(1, tasks.size());
        assertEquals("Buy groceries", tasks.get(0));
    }

    @Test
    public void testRemoveTask() throws Exception {
        tasks.add("Study");
        tasks.add("Gym");

        tasks.remove(0);

        assertEquals(1, tasks.size());
        assertEquals("Gym", tasks.get(0));
    }

    @Test
    public void testEmptyList() {
        assertTrue(tasks.isEmpty());
    }
}
