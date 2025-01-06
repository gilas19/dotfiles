# from huggingface_hub import InferenceClient
import sys, os
import tkinter as tk
from tkinter import ttk

if __name__ == "__main__":
    # client = InferenceClient(api_key="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")
    input = sys.argv[1]

    messages = [{"role": "user", "content": f"explain {input}"}]

    # stream = client.chat.completions.create(
    #     model="microsoft/Phi-3.5-mini-instruct",
    #     messages=messages,
    #     max_tokens=500,
    #     stream=True
    # )

    # for chunk in stream:
    #     print(chunk.choices[0].delta.content, end="")

    full_response = input  # ""
    # stream = client.chat.completions.create(
    #     model="microsoft/Phi-3.5-mini-instruct",
    #     messages=messages,
    #     max_tokens=500,
    #     stream=True
    # )

    # for chunk in stream:
    #     content = chunk.choices[0].delta.content
    #     if content is not None:  # Check if content exists
    #         full_response += content

    # message = full_response.replace('"', '\\"')
    # os.system(
    #     f'osascript -e \'display dialog "{message}" with title "Explanation for: {input}" buttons {{"OK"}} default button "OK"\''
    # )

    title = f"Explanation for: {input}"
    # Create the main window
    window = tk.Tk()
    window.title(title)
    
    # Create a text widget with scrollbar
    text_widget = tk.Text(window, wrap=tk.WORD, width=50, height=10)
    scrollbar = ttk.Scrollbar(window, orient="vertical", command=text_widget.yview)
    text_widget.configure(yscrollcommand=scrollbar.set)
    
    # Pack the widgets
    text_widget.pack(side="left", fill="both", expand=True)
    scrollbar.pack(side="right", fill="y")
    
    # Insert the text
    text_widget.insert("1.0", full_response)
    text_widget.config(state="disabled")  # Make text read-only
    
    # Center the window on screen
    window.update_idletasks()
    width = window.winfo_width()
    height = window.winfo_height()
    x = (window.winfo_screenwidth() // 2) - (width // 2)
    y = (window.winfo_screenheight() // 2) - (height // 2)
    window.geometry(f'{width}x{height}+{x}+{y}')
    
    window.mainloop()
