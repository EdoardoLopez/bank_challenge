defmodule BankUIWeb.Components do
  @moduledoc """
  Reusable components
    - modal
    - success_toast
    - error_alert_list
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def success_toast(assigns) do
    ~H"""
    <div phx-value-key="info" id="toast-success" class="z-50 absolute top-5 right-5 flex items-center w-full max-w-xs p-4 mb-4 text-gray-500 bg-white rounded-lg shadow-lg" role="alert">
      <div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-green-500 bg-green-100 rounded-lg">
        <svg aria-hidden="true" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path></svg>
        <span class="sr-only">Check icon</span>
      </div>
      <!--<div class="ml-3 text-sm font-normal">
      </div>-->
      <%= render_slot(@inner_block) %>
      <button phx-click="lv:clear-flash" type="button" class="ml-auto -mx-1.5 -my-1.5 bg-white text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-gray-100 inline-flex h-8 w-8" data-dismiss-target="#toast-success" aria-label="Close">
        <span class="sr-only">Close</span>
        <svg aria-hidden="true" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path></svg>
      </button>
    </div>
    """
  end

  def error_alert_list(assigns) do
    ~H"""
    <div id={"#{@id}-errors"} class="flex flex-col p-4 mb-4 text-sm text-red-800 rounded-lg bg-red-50" role="alert">
      <div class="flex flex-row">
        <div>
          <svg aria-hidden="true" class="flex-shrink-0 inline w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"></path></svg>
          <span class="font-medium">One or more errors happened:</span>
        </div>
        <button phx-click="lv:clear-flash" type="button" class="ml-auto -mx-1.5 -my-1.5 bg-red-50 text-red-500 rounded-lg focus:ring-2 focus:ring-red-400 p-1.5 hover:bg-red-200 inline-flex h-8 w-8" aria-label="Close">
          <span class="sr-only">Close</span>
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path></svg>
        </button>
      </div>
      <div>
        <ul class="mt-1.5 ml-4 list-disc list-inside">
          <%= render_slot(@inner_block) %>
        </ul>
      </div>
    </div>
    """
  end

  def modal(assigns) do
    ~H"""
    <!-- Modal Component -->
    <div id={@id} tabindex="-1" 
      data-show={open_modal(@id)}
      data-hide={hide_modal(@id)}
      class={"phx-modal hidden fixed top-0 left-0 right-0 z-50 w-full p-4 overflow-x-hidden overflow-y-auto md:inset-0 h-modal md:h-full justify-center items-center flex"}>
      <div class={"relative w-full h-full #{modal_size(@modal_size)} md:h-auto"}>
        <!-- Modal content -->
        <div id={"#{@id}-container"} phx-click-away={hide_modal(@id)} phx-key="escape" class={"relative bg-white rounded-lg shadow"}>
          <!-- Modal header -->
          <div class="flex items-center justify-between p-5 border-b rounded-t">
            <h3 class="capitalize text-xl font-medium text-gray-900">
              <%= @title %>
            </h3>
            <button phx-click={hide_modal(@id)} type="button" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center" data-modal-hide="small-modal">
              <svg aria-hidden="true" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path></svg>
              <span class="sr-only">Close modal</span>
            </button>
          </div>
          <!-- Modal body -->
          <div class="p-4 space-y-2">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def open_modal(js \\ %JS{}, id) do
    js
    |> JS.show(
      to: "##{id}",
      display: "flex",
      transition: {"ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "##{id}-container",
      transition:
        {"ease-out duration-300", "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}",
      transition: {"ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "##{id}-container",
      transition:
        {"ease-in duration-200", "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  defp modal_size(size) when size == "small", do: "max-w-md"
  defp modal_size(size) when size == "medium", do: "max-w-lg"
  defp modal_size(size) when size == "large", do: "max-w-4xl"
  defp modal_size(size) when size == "extralarge", do: "max-w-7xl"
  defp modal_size(_size), do: "max-w-md"
end
