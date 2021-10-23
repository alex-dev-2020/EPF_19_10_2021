
//Стандартные атрибуты 
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.РеализацияТоваровУслуг");     
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма");
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "Реализация товаров и услуг Альтерра");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", ЛОЖЬ);
	ПараметрыРегистрации.Вставить("Версия", "2.0.13");    
	ПараметрыРегистрации.Вставить("Информация", "Альтерра  ВПФ ТЗ");   
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, "Альтерра  ВПФ ТЗ", "РеализацияТоваровИУслуг_Альтерра", "ВызовСерверногоМетода", Истина, "ПечатьMXL");
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицуКоманд()
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка")); 
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Возврат Команды;
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;  
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

//Печать

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	//Печатаем ЕДИНСТВЕННЫЙ ОБЪЕКТ (ПЕРВЫЙ - > МассивОбъектов[0]), 
	//при групповой печати  Документов необходимо 
	//реализовать обход массива  в цикле 
	//+ разделитель 
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
	"РеализацияТоваровИУслуг_Альтерра", 
	"Альтерра ВПФ ТЗ", 
	СформироватьПечатнуюФорму(МассивОбъектов[0], ОбъектыПечати));
	
КонецПроцедуры 


Функция СформироватьПечатнуюФорму(СсылкаНаДокумент, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеализацияТоваровИУслуг_Альтерра";
	МакетОбработки = ПолучитьМакет("РеализацияТиУАльтерра");
	
	//заполняем шапку
	ОбластьШапка = МакетОбработки.ПолучитьОбласть("Шапка");	
	ОбластьШапка.Параметры.ДатаДокумента = СсылкаНаДокумент.Дата;
	ОрганизацияПокупатель = СсылкаНаДокумент.Контрагент.Наименование;
	ОбластьШапка.Параметры.ОрганизацияПокупатель = ОрганизацияПокупатель;   
	ОбластьШапка.Параметры.КонтактноеЛицо = СсылкаНаДокумент.КонтактноеЛицо;
	
	//Выгружаем колонку из ТЧ КонтактнаяИнформация Справочника Партнеры
	ПокупательКонтактнаяИнформация = 
		Справочники.Партнеры.НайтиПоНаименованию(ОрганизацияПокупатель).
		КонтактнаяИнформация.ВыгрузитьКолонку("НомерТелефона");
	
	//обходим массив, проверяя заполненные
	//заполненный - > возвращаем как номер телефона
	Для Каждого Элемент из ПокупательКонтактнаяИнформация Цикл 
		Если НЕ ЗначениеЗаполнено(Элемент)Тогда
			Продолжить;
		КонецЕсли;
		ОбластьШапка.Параметры.Телефон = Элемент;	
	КонецЦикла;
	
	//выводим шапку в табличный документ 
	ТабличныйДокумент.Вывести(ОбластьШапка);   
	
	
	//Работа с ТЧ
	//Выводим шапку ТЧ	
	ШапкаТЧ = МакетОбработки.ПолучитьОбласть("ШапкаТЧ");
	ТабличныйДокумент.Вывести(ШапкаТЧ);
	
	//Создаем структуру для хранения Итогов
	ИтоговыеСуммы = СтруктураИтоговыеСуммы();
	
	//заполняем строки ТЧ                                                
	ОбластьСтроки = МакетОбработки.ПолучитьОбласть("ТЧДокумента");
	НомерСтроки = 1;
	Для Каждого ТекущаяСтрока Из СсылкаНаДокумент.Товары Цикл
		ОбластьСтроки.Параметры.НомерСтроки = НомерСтроки; 
		ЗаполнитьЗначенияСвойств(ОбластьСтроки.Параметры, ТекущаяСтрока);
		РассчитатьИтоговыеСуммы(ИтоговыеСуммы, ТекущаяСтрока);
		ТабличныйДокумент.Вывести(ОбластьСтроки);
		НомерСтроки = НомерСтроки + 1 ;
	КонецЦикла;
	
	//заполняем Итоги
	ОбластьИтоги = МакетОбработки.ПолучитьОбласть("Итоги");
	ОбластьИтоги.Параметры.Заполнить(ИтоговыеСуммы);
	
	//выводим Итоги в табличный документ 
	ТабличныйДокумент.Вывести(ОбластьИтоги);
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;	
	
КонецФункции        


//Формирование Структуры Итогов
Функция СтруктураИтоговыеСуммы()
	
	Структура = Новый Структура;
	
	СтруктураРесурсовДляИтогов = СтруктураРесурсовДляИтогов();
	
	Для Каждого Элемент Из СтруктураРесурсовДляИтогов Цикл
		Структура.Вставить("Итого"+Элемент.Ключ, 0);
	КонецЦикла;
	
	Возврат Структура;
	
КонецФункции

//Считаем Итоговые Суммы нарастающим итогом
Процедура РассчитатьИтоговыеСуммы(ИтоговыеСуммы, СтрокаТовары)
	СтруктураСуммПоСтроке = СтруктураРесурсовДляИтогов();
	
	//Заполняем только то, что использовано в текущем Документе
	ЗаполнитьЗначенияСвойств(СтруктураСуммПоСтроке, СтрокаТовары);
	
	//Считаем по каждому использованому ключу нарастающим итогом
	Для Каждого Элемент Из СтруктураСуммПоСтроке Цикл
		Если ЗначениеЗаполнено(Элемент.Значение) Тогда
			ИтоговыеСуммы["Итого"+Элемент.Ключ] = ИтоговыеСуммы["Итого"+Элемент.Ключ] + Элемент.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

//Определяем стркутуру  Ресурсов для Итогов (согласно ТЗ)
Функция СтруктураРесурсовДляИтогов()
	Структура = Новый Структура;
	Структура.Вставить("Количество", 0);
	Структура.Вставить("Сумма", 0);
	Структура.Вставить("Вес", 0);
	Структура.Вставить("Объем", 0);
	
	Возврат Структура;
КонецФункции

