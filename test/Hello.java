public class Hello {
    public static void main(String[] args) {
        final Runnable runnable = () -> System.out.println("Hello world!"); // Java 8+
        runnable.run();
    }
}