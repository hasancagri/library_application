namespace WebApi.Services;

public class BookManager
{
    private List<Book> books = new List<Book>();

    public BookManager()
    {
        // Örnek veriler
        books.AddRange(new List<Book>
        {
            new Book { Id = 1, Title = "1984", Author = "George Orwell" },
            new Book { Id = 2, Title = "Suç ve Ceza", Author = "Fyodor Dostoyevski" },
            new Book { Id = 3, Title = "Yüzüklerin Efendisi", Author = "J.R.R. Tolkien" },
            new Book { Id = 4, Title = "Simyacı", Author = "Paulo Coelho" },
            new Book { Id = 5, Title = "Sefiller", Author = "Victor Hugo" },
            new Book { Id = 6, Title = "Kürk Mantolu Madonna", Author = "Sabahattin Ali" },
            new Book { Id = 7, Title = "Gurur ve Önyargı", Author = "Jane Austen" },
            new Book { Id = 8, Title = "Bülbülü Öldürmek", Author = "Harper Lee" },
            new Book { Id = 9, Title = "Catcher in the Rye", Author = "J.D. Salinger" },
            new Book { Id = 10, Title = "İnce Memed", Author = "Yaşar Kemal" },
            new Book { Id = 11, Title = "Kayıp Zamanın İzinde", Author = "Marcel Proust" },
            new Book { Id = 12, Title = "Savaş ve Barış", Author = "Lev Tolstoy" },
            new Book { Id = 13, Title = "Yalnızız", Author="Peyami Safa" }
        });
    }

    public void AddBook(Book book)
    {
        books.Add(book);
    }

    public IEnumerable<Book> GetAllBooks()
    {
        return books;
    }

    public Book GetBookById(int id)
    {
        return books.FirstOrDefault(b => b.Id == id);
    }

    public void RemoveBook(int id)
    {
        var book = GetBookById(id);
        if (book != null)
        {
            books.Remove(book);
        }
    }
}