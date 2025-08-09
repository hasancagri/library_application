var builder = WebApplication.CreateBuilder(args);
builder.Services.AddScoped<BookManager>();
var app = builder.Build();


app.MapGet("/books", (BookManager bookManager) =>
{
    return bookManager.GetAllBooks();
});

app.MapGet("/books/{id}", (int id, BookManager bookManager) =>
{
    var book = bookManager.GetBookById(id);
    return book != null ? Results.Ok(book) : Results.NotFound();
});

app.MapPost("/books", (Book book, BookManager bookManager) =>
{
    bookManager.AddBook(book);
    return Results.Created($"/books/{book.Id}", book);
});

app.MapDelete("/books/{id}", (int id, BookManager bookManager) =>
{
    bookManager.RemoveBook(id);
    return Results.NoContent();
});

app.Run();
