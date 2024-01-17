defmodule War do
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add
    as many additional helper functions as you want.

    The tests for the deal function can be found in test/war_test.exs.
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory
    (the one containing mix.exs)
  """

  def deal(shuf) do
    # Replace all the 1's (Aces) into 14's
    shuf = Enum.map(shuf, fn x -> if x == 1, do: 14, else: x end)
    # Split the deck into based on even or odd indexes.
    {deckOne, deckTwo, _} = Enum.reduce(shuf, {[], [], 0}, fn(element, {odd_list, even_list, count}) ->
      if rem(count, 2) == 0 do
        {odd_list, even_list ++ [element], count + 1}
      else
        {odd_list ++ [element], even_list, count + 1}
      end
    end)
    # Reverse the decks so that I am accessing the top of them.
    deckOne = Enum.reverse(deckOne)
    deckTwo = Enum.reverse(deckTwo)
    # Play the game, returns a tuple of all the modified decks.
    {d1,d2,s} = play(deckTwo, deckOne, [])
    # Return the deck that isn't empty
    if (length(d1) == 0 and length(d2) == 0) do
      Enum.map(s, fn x -> if x == 14, do: 1, else: x end)
    else
      if (length(d1) != 0) do
        Enum.map(d1 ++ s, fn x -> if x == 14, do: 1, else: x end)
      else
        Enum.map(d2 ++ s, fn x -> if x == 14, do: 1, else: x end)
      end
    end
  end

  def play(deckOne, deckTwo, stash) do
    # Base case if either deckOne or deckTwo is empty
    if (length(deckOne) == 0) or (length(deckTwo) == 0) do
      # Return a 3 tuple of the modified decks
      {deckOne, deckTwo, stash}
    else
      # Get the top cards of each deck and store the remaning cards
      pOneTop = hd(deckOne)
      pOneDeck = tl(deckOne)
      pTwoTop = hd(deckTwo)
      pTwoDeck = tl(deckTwo)
      # Add the top cards to the stash
      stash = stash ++ [pOneTop] ++ [pTwoTop]
      # Sort the stash
      stash = Enum.sort(stash, :desc)
      # If top two are equal, there is War
      if (pOneTop == pTwoTop) do
        # Checks in case the last play is War where one deck has nothing after. Just add it to the deck that isn't empty.
        if (length(pOneDeck) == 0) or (length(pTwoDeck) == 0) do
          if (length(pOneDeck) == 0 and length(pTwoDeck) != 0) do
            play(pOneDeck, pTwoDeck ++ stash, [])
          else
            play(pOneDeck ++ stash, pTwoDeck, [])
          end
        # Otherwise, add cards to stash and call play function again.
        else
          oneDown = hd(pOneDeck)
          oneRest = tl(pOneDeck)
          twoDown = hd(pTwoDeck)
          twoRest = tl(pTwoDeck)
          stash = stash ++ [oneDown] ++ [twoDown]
          stash = Enum.sort(stash, :desc)
          play(oneRest, twoRest, stash)
        end
      # If not War
      else
        # Player One wins, add stash to deck and, call again.
        if (pOneTop > pTwoTop) do
          play(pOneDeck ++ stash, pTwoDeck, [])
        # Player Two wins, add stash to deck and, call again.
        else
          play(pOneDeck, pTwoDeck ++ stash, [])
        end
      end
    end
  end
end
